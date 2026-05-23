import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/services/ai_service.dart';
import 'package:montage/repositories/transaction_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TransactionProvider extends ChangeNotifier {
  late TransactionRepository _repository;
  late final AIService _aiService;
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

  TransactionProvider({TransactionRepository? repository}) {
    if (repository != null) {
      _repository = repository;
    }
    _aiService = AIService(_geminiApiKey);
  }

  void updateRepository(TransactionRepository repository) {
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

  void _checkBalanceAndTriggerHaptic() {
    if (totalBalance < 0) {
      HapticFeedback.heavyImpact();
    }
  }

  void _invalidateInsights() {
    _cachedInsights = null;
    refreshInsights();
  }

  void _loadTransactions() {
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
    _checkBalanceAndTriggerHaptic();
  }

  Future<void> deleteTransaction(int key, int index) async {
    // Soft delete logic
    final txIndex = _transactions.indexWhere((t) => t.key == key);
    if (txIndex != -1) {
      final tx = _transactions[txIndex];
      tx.isArchived = true;
      await _repository.update(key, tx);
      _loadTransactions();
      _checkBalanceAndTriggerHaptic();
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
    _checkBalanceAndTriggerHaptic();
  }

  Future<void> restoreAllTransactions() async {
    for (var tx in _transactions) {
      if (tx.isArchived) {
        tx.isArchived = false;
        await _repository.update(tx.key as int, tx);
      }
    }
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();
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
    _checkBalanceAndTriggerHaptic();
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await _repository.update(key, updatedTx);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();
  }

  double get totalIncome => FinanceService.calculateTotalIncome(_transactions);

  double get totalExpense =>
      FinanceService.calculateTotalExpense(_transactions);

  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_transactions);

  List<TransactionModel> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_transactions, isIncome);
  }

  List<FinancialPeriodData> get weeklyFinancialSummary {
    final Map<String, FinancialPeriodData> dayMap = {
      'Mon': FinancialPeriodData(
        label: 'Mon',
        date: _getThisWeekDay(DateTime.monday),
        income: 0,
        expense: 0,
      ),
      'Tue': FinancialPeriodData(
        label: 'Tue',
        date: _getThisWeekDay(DateTime.tuesday),
        income: 0,
        expense: 0,
      ),
      'Wed': FinancialPeriodData(
        label: 'Wed',
        date: _getThisWeekDay(DateTime.wednesday),
        income: 0,
        expense: 0,
      ),
      'Thu': FinancialPeriodData(
        label: 'Thu',
        date: _getThisWeekDay(DateTime.thursday),
        income: 0,
        expense: 0,
      ),
      'Fri': FinancialPeriodData(
        label: 'Fri',
        date: _getThisWeekDay(DateTime.friday),
        income: 0,
        expense: 0,
      ),
      'Sat': FinancialPeriodData(
        label: 'Sat',
        date: _getThisWeekDay(DateTime.saturday),
        income: 0,
        expense: 0,
      ),
      'Sun': FinancialPeriodData(
        label: 'Sun',
        date: _getThisWeekDay(DateTime.sunday),
        income: 0,
        expense: 0,
      ),
    };

    for (var tx in _transactions) {
      DateTime? parsedDate = DateUtilsCustom.parseDate(tx.date);
      if (parsedDate == null) {
        continue;
      }
      String day = DateFormat('E').format(parsedDate);
      if (dayMap.containsKey(day)) {
        if (tx.isIncome) {
          dayMap[day] = dayMap[day]!.copyWith(
            income: dayMap[day]!.income + tx.amount,
          );
        } else {
          dayMap[day] = dayMap[day]!.copyWith(
            expense: dayMap[day]!.expense + tx.amount,
          );
        }
      }
    }
    return dayMap.values.toList().cast<FinancialPeriodData>();
  }

  DateTime _getThisWeekDay(int dayOfWeek) {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - dayOfWeek));
  }
}
