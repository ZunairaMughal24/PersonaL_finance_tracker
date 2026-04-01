import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/core/utils/date_formatter.dart';
class TransactionFilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool _isIncomeFilter = false;

  String get searchQuery => _searchQuery;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedCategory => _selectedCategory;
  bool get isIncomeFilter => _isIncomeFilter;

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    if (_selectedDateRange == range) return;
    _selectedDateRange = range;
    notifyListeners();
  }

  void setCategory(String? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void setIsIncomeFilter(bool value) {
    if (_isIncomeFilter == value) return;
    _isIncomeFilter = value;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedDateRange = null;
    _selectedCategory = null;
    _isIncomeFilter = false;
    notifyListeners();
  }

  List<TransactionModel> filterTransactions(List<TransactionModel> transactions) {
    return transactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.category.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesDate = true;
      if (_selectedDateRange != null) {
        final txDate = DateUtilsCustom.parseDate(tx.date);
        if (txDate == null) {
          matchesDate = false;
        } else {
          matchesDate = txDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
              txDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        }
      }

      bool matchesCategory = true;
      if (_selectedCategory != null && _selectedCategory != 'All') {
        matchesCategory = tx.category == _selectedCategory;
      }

      final matchesType = tx.isIncome == _isIncomeFilter;

      return matchesSearch && matchesDate && matchesCategory && matchesType;
    }).toList();
  }
}
