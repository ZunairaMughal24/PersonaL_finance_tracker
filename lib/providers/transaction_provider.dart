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
import 'package:montage/domain/use_cases/restore_transactions_use_case.dart';
import 'package:montage/domain/use_cases/clear_dashboard_use_case.dart';
import 'package:montage/domain/use_cases/restore_all_transactions_use_case.dart';
import 'package:montage/domain/use_cases/get_ai_insights_use_case.dart';

class TransactionProvider extends ChangeNotifier {
  late ITransactionRepository _repository;
  final GetAiInsightsUseCase _getInsights;
  late ArchiveTransactionUseCase _archiveTransaction;
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
  List<Transaction> get transactions =>
      _transactions.where((tx) => !tx.isArchived).toList();
  List<Transaction> get archivedTransactions =>
      _transactions.where((tx) => tx.isArchived).toList();
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

  Future<void> deleteTransaction(int id) async {
    await _archiveTransaction(id);
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

  double get totalIncome => FinanceService.calculateTotalIncome(_transactions);
  double get totalExpense => FinanceService.calculateTotalExpense(_transactions);
  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_transactions);

  List<Transaction> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_transactions, isIncome);
  }

  List<FinancialPeriodData> get weeklyFinancialSummary =>
      FinanceService.getWeeklyFinancialSummary(_transactions);
}
