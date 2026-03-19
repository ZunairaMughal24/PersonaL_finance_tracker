import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/services/database_services.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/services/ai_service.dart';

class TransactionProvider extends ChangeNotifier {
  DatabaseService? db;
  late final AIService _aiService;
  String? _userId;

  static const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  List<TransactionModel> _transactions = [];
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter = false;
  String? _cachedInsights;
  Future<String?>? _insightsFuture;

  List<TransactionModel> get transactions => _transactions;
  Future<String?>? get insightsFuture => _insightsFuture;
  String? get cachedInsightsValue => _cachedInsights;
  
  TransactionProvider() {
    _aiService = AIService(_geminiApiKey);
  }

  void updateUser(String? userId) async {
    if (_userId == userId) return;
    
    _userId = userId;
    if (userId == null) {
      _transactions = [];
      _cachedInsights = null;
      db = null;
      notifyListeners();
      return;
    }

    // Open user-specific box
    final boxName = 'transactions_$userId';
    final box = await Hive.openBox<TransactionModel>(boxName);
    db = DatabaseService(box);
    _loadTransactions();
  }

  void refreshInsights() {
    if (_transactions.isEmpty) {
      _insightsFuture = Future.value(null);
      return;
    }
    // ...
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

  List<TransactionModel> get filteredTransactions {
    return _transactions.where((tx) {
      final matchesSearch =
          tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.category.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesDate = true;
      if (_selectedDateRange != null) {
        final txDate = DateUtilsCustom.parseDate(tx.date);
        matchesDate =
            txDate.isAfter(
              _selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            txDate.isBefore(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            );
      }

      bool matchesCategory = true;
      if (_selectedCategory != null && _selectedCategory != 'All') {
        matchesCategory = tx.category == _selectedCategory;
      }

      bool matchesType = true;
      if (_isIncomeFilter != null) {
        matchesType = tx.isIncome == _isIncomeFilter;
      }

      return matchesSearch && matchesDate && matchesCategory && matchesType;
    }).toList();
  }

  String get searchQuery => _searchQuery;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedCategory => _selectedCategory;
  bool? get isIncomeFilter => _isIncomeFilter;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setIsIncomeFilter(bool? value) {
    _isIncomeFilter = value;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedDateRange = null;
    _selectedCategory = null;
    _isIncomeFilter = null;
    notifyListeners();
  }

  void _loadTransactions() {
    if (db == null) return;
    _transactions = db!.getAllTransaction();
    _invalidateInsights();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    if (db == null) return;
    await db!.addTransaction(tx);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();
  }

  Future<void> deleteTransaction(int key, int index) async {
    if (db == null) return;
    await db!.deleteTransaction(key);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    if (db == null) return;
    await db!.updateTransaction(key, updatedTx);
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
      'Mon': FinancialPeriodData(label: 'Mon', date: _getThisWeekDay(DateTime.monday), income: 0, expense: 0),
      'Tue': FinancialPeriodData(label: 'Tue', date: _getThisWeekDay(DateTime.tuesday), income: 0, expense: 0),
      'Wed': FinancialPeriodData(label: 'Wed', date: _getThisWeekDay(DateTime.wednesday), income: 0, expense: 0),
      'Thu': FinancialPeriodData(label: 'Thu', date: _getThisWeekDay(DateTime.thursday), income: 0, expense: 0),
      'Fri': FinancialPeriodData(label: 'Fri', date: _getThisWeekDay(DateTime.friday), income: 0, expense: 0),
      'Sat': FinancialPeriodData(label: 'Sat', date: _getThisWeekDay(DateTime.saturday), income: 0, expense: 0),
      'Sun': FinancialPeriodData(label: 'Sun', date: _getThisWeekDay(DateTime.sunday), income: 0, expense: 0),
    };

    for (var tx in _transactions) {
      DateTime parsedDate = DateUtilsCustom.parseDate(tx.date);
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
    return dayMap.values.toList();
  }
  DateTime _getThisWeekDay(int dayOfWeek) {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - dayOfWeek));
  }
}
