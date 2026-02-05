import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/core/utils/date_formatter.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/models/spending_summary.dart';
import 'package:personal_finance_tracker/models/trends_model.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/services/finance_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService();
  List<TransactionModel> _transactions = [];
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter = false;

  List<TransactionModel> get transactions => _transactions;

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

  TransactionProvider() {
    _loadTransactions();
  }

  void _loadTransactions() {
    _transactions = db.getAllTransaction();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await db.addTransaction(tx);

    _loadTransactions();
  }

  Future<void> deleteTransaction(int key, int index) async {
    await db.deleteTransaction(key);
    _loadTransactions();
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await db.updateTransaction(key, updatedTx);

    _loadTransactions();
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
      'Mon': FinancialPeriodData(label: 'Mon', income: 0, expense: 0),
      'Tue': FinancialPeriodData(label: 'Tue', income: 0, expense: 0),
      'Wed': FinancialPeriodData(label: 'Wed', income: 0, expense: 0),
      'Thu': FinancialPeriodData(label: 'Thu', income: 0, expense: 0),
      'Fri': FinancialPeriodData(label: 'Fri', income: 0, expense: 0),
      'Sat': FinancialPeriodData(label: 'Sat', income: 0, expense: 0),
      'Sun': FinancialPeriodData(label: 'Sun', income: 0, expense: 0),
    };

    for (var tx in _transactions) {
      DateTime parsedDate = DateUtilsCustom.parseDate(tx.date);

      String day = DateFormat('E').format(parsedDate);

      if (dayMap.containsKey(day)) {
        if (tx.isIncome) {
          dayMap[day] = FinancialPeriodData(
            label: day,
            income: dayMap[day]!.income + tx.amount,
            expense: dayMap[day]!.expense,
          );
        } else {
          dayMap[day] = FinancialPeriodData(
            label: day,
            income: dayMap[day]!.income,
            expense: dayMap[day]!.expense + tx.amount,
          );
        }
      }
    }

    return dayMap.values.toList();
  }
}
