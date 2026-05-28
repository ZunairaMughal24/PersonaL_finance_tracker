import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/core/interfaces/i_ai_service.dart';
import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/services/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TransactionProvider extends ChangeNotifier {
  late ITransactionRepository _repository;
  late final IAIService _aiService;
  String? _userId;

  static final String _geminiApiKey = dotenv.get(
    'GEMINI_API_KEY',
    fallback: '',
  );

  bool _isReady = false;
  List<TransactionModel> _transactions = [];
  String? _cachedInsights;
  Future<String?>? _insightsFuture;

  bool get isReady => _isReady;
  List<TransactionModel> get transactions =>
      _transactions.where((tx) => !tx.isArchived).toList();

  List<TransactionModel> get archivedTransactions =>
      _transactions.where((tx) => tx.isArchived).toList();

  List<TransactionModel> get allTransactions => _transactions;

  Future<String?>? get insightsFuture => _insightsFuture;
  String? get cachedInsightsValue => _cachedInsights;

  TransactionProvider({
    ITransactionRepository? repository,
    IAIService? aiService,
  }) {
    if (repository != null) {
      _repository = repository;
    }
    _aiService = aiService ?? AIService(_geminiApiKey);
  }

  void updateRepository(ITransactionRepository repository) {
    _repository = repository;
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
    _loadTransactions();
    _isReady = true;
    notifyListeners();
  }

  void refreshInsights() {
    if (_transactions.isEmpty) {
      _insightsFuture = Future.value(null);
      return;
    }
    _insightsFuture = _aiService
        .getSuggestionsAndAppreciation(_transactions)
        .then((val) {
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

  Future<void> fetchTransactions() async {
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _repository.add(tx);
    _loadTransactions();
  }

  Future<void> deleteTransaction(int key, int index) async {
    final txIndex = _transactions.indexWhere((t) => t.key == key);
    if (txIndex != -1) {
      final tx = _transactions[txIndex];
      tx.isArchived = true;
      await _repository.update(key, tx);
      _loadTransactions();
    }
  }

  Future<void> deletePermanently(List<int> keys) async {
    await _repository.deleteBulk(keys);
    _loadTransactions();
  }

  Future<void> clearDashboard() async {
    final activeTxs = _transactions.where((t) => !t.isArchived).toList();
    for (var tx in activeTxs) {
      tx.isArchived = true;
      await _repository.update(tx.key as int, tx);
    }
    _loadTransactions();
  }

  Future<void> restoreAllTransactions() async {
    for (var tx in _transactions) {
      if (tx.isArchived) {
        tx.isArchived = false;
        await _repository.update(tx.key as int, tx);
      }
    }
    _loadTransactions();
  }

  Future<void> restoreTransactions(List<int> keys) async {
    for (var key in keys) {
      final txIndex = _transactions.indexWhere((t) => t.key == key);
      if (txIndex != -1) {
        final tx = _transactions[txIndex];
        tx.isArchived = false;
        await _repository.update(key, tx);
      }
    }
    _loadTransactions();
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await _repository.update(key, updatedTx);
    _loadTransactions();
  }

  double get totalIncome => FinanceService.calculateTotalIncome(_transactions);

  double get totalExpense =>
      FinanceService.calculateTotalExpense(_transactions);

  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  double get totalBalanceWithArchived => FinanceService.calculateBalance(
    FinanceService.calculateTotalIncome(_transactions),
    FinanceService.calculateTotalExpense(_transactions),
  );

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_transactions);

  List<TransactionModel> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_transactions, isIncome);
  }

  List<FinancialPeriodData> get weeklyFinancialSummary =>
      FinanceService.getWeeklyFinancialSummary(_transactions);
}
