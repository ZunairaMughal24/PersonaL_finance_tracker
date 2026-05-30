import 'dart:async';
import 'package:flutter/material.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/core/interfaces/i_ai_service.dart';
import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/core/enums/sync_status.dart';
import 'package:montage/domain/use_cases/archive_transaction_use_case.dart';
import 'package:montage/domain/use_cases/soft_delete_transaction_use_case.dart';
import 'package:montage/domain/use_cases/restore_transactions_use_case.dart';
import 'package:montage/domain/use_cases/clear_dashboard_use_case.dart';
import 'package:montage/domain/use_cases/restore_all_transactions_use_case.dart';
import 'package:montage/domain/use_cases/get_ai_insights_use_case.dart';

class TransactionProvider extends ChangeNotifier {
  late ITransactionRepository _repository;
  final GetAiInsightsUseCase _getInsights;
  late ArchiveTransactionUseCase _archiveTransaction;
  late SoftDeleteTransactionUseCase _softDeleteTransaction;
  late RestoreTransactionsUseCase _restoreTransactions;
  late ClearDashboardUseCase _clearDashboard;
  late RestoreAllTransactionsUseCase _restoreAll;

  String? _userId;
  bool _isReady = false;
  List<Transaction> _transactions = [];
  String? _cachedInsights;
  Future<String?>? _insightsFuture;
  SyncStatus _syncStatus = SyncStatus.idle;
  StreamSubscription? _syncSubscription;

  bool get isReady => _isReady;
  // Active — visible in Activity screen
  List<Transaction> get transactions =>
      _transactions.where((tx) => !tx.isArchived && !tx.isDeleted).toList();

  // Archived — clean from view, balance still counts
  List<Transaction> get archivedTransactions =>
      _transactions.where((tx) => tx.isArchived && !tx.isDeleted).toList();

  // Deleted — moved to History, excluded from balance
  List<Transaction> get deletedTransactions =>
      _transactions.where((tx) => tx.isDeleted).toList();

  List<Transaction> get allTransactions => _transactions;
  Future<String?>? get insightsFuture => _insightsFuture;
  String? get cachedInsightsValue => _cachedInsights;
  SyncStatus get syncStatus => _syncStatus;

  TransactionProvider({
    ITransactionRepository? repository,
    required IAIService aiService,
  }) : _getInsights = GetAiInsightsUseCase(aiService) {
    if (repository != null) {
      _repository = repository;
      _initUseCases(repository);
    }
  }

  void updateRepository(ITransactionRepository repository) {
    _repository = repository;
    _initUseCases(repository);
    _listenToSync();
  }

  void _initUseCases(ITransactionRepository repository) {
    _archiveTransaction = ArchiveTransactionUseCase(repository);
    _softDeleteTransaction = SoftDeleteTransactionUseCase(repository);
    _restoreTransactions = RestoreTransactionsUseCase(repository);
    _clearDashboard = ClearDashboardUseCase(repository);
    _restoreAll = RestoreAllTransactionsUseCase(repository);
  }

  void _listenToSync() {
    _syncSubscription?.cancel();
    _syncSubscription = _repository.syncStatus.listen((status) {
      _syncStatus = status;
      if (status == SyncStatus.success) _loadTransactions();
      notifyListeners();
    });
  }

  void updateUser(String? userId) async {
    if (_userId == userId) return;
    _isReady = false;
    _userId = userId;

    if (userId == null) {
      _transactions = [];
      _cachedInsights = null;
      _isReady = true;
      notifyListeners();
      return;
    }

    await _repository.init(userId);
    _listenToSync();
    _loadTransactions();
    _isReady = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    super.dispose();
  }

  void refreshInsights() {
    if (_transactions.isEmpty) {
      _insightsFuture = Future.value(null);
      return;
    }
    _insightsFuture = _getInsights(_transactions).then((val) {
      _cachedInsights = val;
      return val;
    });
    notifyListeners();
  }

  void _invalidateInsights() {
    _cachedInsights = null;
    refreshInsights();
  }

  void _loadTransactions() {
    if (!_repository.isInitialized) return;
    _transactions = _repository.getAll();
    _invalidateInsights();
    notifyListeners();
  }

  Future<void> fetchTransactions() async => _loadTransactions();

  Future<void> addTransaction(Transaction tx) async {
    await _repository.add(
      tx.copyWith(lastModified: DateTime.now().millisecondsSinceEpoch),
    );
    _loadTransactions();
  }

  // Soft delete — moves to History, excluded from balance
  Future<void> deleteTransaction(int id) async {
    await _softDeleteTransaction(id);
    _loadTransactions();
  }

  // Archive — cleans from active view, balance unchanged
  Future<void> archiveTransaction(int id) async {
    await _archiveTransaction(id);
    _loadTransactions();
  }

  Future<void> archiveTransactions(List<int> ids) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = <int, Transaction>{};
    for (final tx in _repository.getAll()) {
      if (tx.id != null && ids.contains(tx.id) && !tx.isArchived) {
        updates[tx.id!] = tx.copyWith(isArchived: true, isDeleted: false, lastModified: now);
      }
    }
    if (updates.isNotEmpty) await _repository.updateBulk(updates);
    _loadTransactions();
  }

  Future<void> softDeleteTransactions(List<int> ids) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = <int, Transaction>{};
    for (final tx in _repository.getAll()) {
      if (tx.id != null && ids.contains(tx.id) && !tx.isDeleted) {
        updates[tx.id!] = tx.copyWith(isDeleted: true, isArchived: false, lastModified: now);
      }
    }
    if (updates.isNotEmpty) await _repository.updateBulk(updates);
    _loadTransactions();
  }

  Future<void> deletePermanently(List<int> ids) async {
    await _repository.deleteBulk(ids);
    _loadTransactions();
  }

  Future<void> clearDashboard() async {
    await _clearDashboard();
    _loadTransactions();
  }

  Future<void> restoreAllTransactions() async {
    await _restoreAll();
    _loadTransactions();
  }

  Future<void> restoreTransactions(List<int> ids) async {
    await _restoreTransactions(ids);
    _loadTransactions();
  }

  Future<void> updateTransaction(int id, Transaction tx) async {
    await _repository.update(
      id,
      tx.copyWith(lastModified: DateTime.now().millisecondsSinceEpoch),
    );
    _loadTransactions();
  }

  // Active + Archived (not deleted) — used for all balance calculations
  List<Transaction> get _balanceTransactions =>
      _transactions.where((tx) => !tx.isDeleted).toList();

  double get totalIncome =>
      FinanceService.calculateTotalIncome(_balanceTransactions);
  double get totalExpense =>
      FinanceService.calculateTotalExpense(_balanceTransactions);
  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  String get displayCurrency =>
      _balanceTransactions.isNotEmpty ? _balanceTransactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_balanceTransactions);

  List<Transaction> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_balanceTransactions, isIncome);
  }

  List<FinancialPeriodData> get weeklyFinancialSummary =>
      FinanceService.getWeeklyFinancialSummary(_balanceTransactions);
}
