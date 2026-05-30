import 'package:flutter/material.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/core/utils/transaction_filter_utils.dart';

class TransactionFilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter;

  String get searchQuery => _searchQuery;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedCategory => _selectedCategory;
  bool? get isIncomeFilter => _isIncomeFilter;

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
    final normalized = (category == 'All') ? null : category;
    if (_selectedCategory == normalized) return;
    _selectedCategory = normalized;
    notifyListeners();
  }

  void setIsIncomeFilter(bool? value) {
    if (_isIncomeFilter == value) return;
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

  List<Transaction> filterTransactions(List<Transaction> transactions) {
    final filtered = TransactionFilterUtils.filter(
      transactions: transactions,
      query: _searchQuery,
      dateRange: _selectedDateRange,
      category: _selectedCategory,
      isIncome: _isIncomeFilter,
    );
    TransactionFilterUtils.sortByDate(filtered);
    return filtered;
  }
}
