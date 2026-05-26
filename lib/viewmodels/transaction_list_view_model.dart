import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/core/utils/transaction_filter_utils.dart';

class TransactionListViewModel extends ChangeNotifier {
  final TransactionProvider _transactionProvider;
  final bool isHistoryMode;

  String _searchQuery = "";
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter; // null means 'All'
  final Set<int> _selectedKeys = {};
  bool _isSelectionMode = false;
  bool _isSearchVisible = false;

  TransactionListViewModel(
    this._transactionProvider, {
    required this.isHistoryMode,
  }) {
    _transactionProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _transactionProvider.removeListener(notifyListeners);
    super.dispose();
  }

  // Getters
  String get searchQuery => _searchQuery;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedCategory => _selectedCategory;
  bool? get isIncomeFilter => _isIncomeFilter;
  Set<int> get selectedKeys => _selectedKeys;
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selectedKeys.length;
  bool get isSearchVisible => _isSearchVisible;

  List<TransactionModel> get filteredTransactions {
    final baseTransactions = isHistoryMode
        ? _transactionProvider.archivedTransactions
        : _transactionProvider.transactions;

    final filtered = TransactionFilterUtils.filter(
      transactions: baseTransactions,
      query: _searchQuery,
      dateRange: _selectedDateRange,
      category: _selectedCategory,
      isIncome: _isIncomeFilter,
    );

    TransactionFilterUtils.sortByDate(filtered);
    return filtered;
  }

  // Logic
  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchVisible = !_isSearchVisible;
    if (!_isSearchVisible) {
      _searchQuery = "";
    }
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

  void setIsIncomeFilter(bool? isIncome) {
    _isIncomeFilter = isIncome;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = "";
    _selectedDateRange = null;
    _selectedCategory = null;
    _isIncomeFilter = null;
    notifyListeners();
  }

  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedKeys.clear();
    }
    notifyListeners();
  }

  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void toggleSelection(int key) {
    if (_selectedKeys.contains(key)) {
      _selectedKeys.remove(key);
      if (_selectedKeys.isEmpty) {
        _isSelectionMode = false;
      }
    } else {
      _selectedKeys.add(key);
      _isSelectionMode = true;
    }
    notifyListeners();
  }

  void selectAll([List<int>? keys]) {
    final targets =
        keys ?? filteredTransactions.map((tx) => tx.key as int).toList();
    _selectedKeys.addAll(targets);
    _isSelectionMode = true;
    notifyListeners();
  }

  void deselectAll() {
    _selectedKeys.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  // Alias for UI compatibility
  void clearSelection() => deselectAll();

  Future<void> deleteSelected() async {
    await _transactionProvider.deletePermanently(_selectedKeys.toList());
    _selectedKeys.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  // Alias for UI compatibility (Legacy terminology)
  Future<void> archiveSelected() => deleteSelected();

  Future<void> restoreSelected() async {
    await _transactionProvider.restoreTransactions(_selectedKeys.toList());
    _selectedKeys.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> restoreAll() async {
    await _transactionProvider.restoreAllTransactions();
    notifyListeners();
  }

  Future<void> deleteSingleTransaction(int key) async {
    await _transactionProvider.deleteTransaction(key, 0);
    notifyListeners();
  }
}
