import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/core/utils/transaction_filter_utils.dart';

class HistoryViewModel extends ChangeNotifier {
  final TransactionProvider _transactionProvider;

  String _searchQuery = "";
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter; // null means 'All'
  final Set<int> _selectedKeys = {};
  bool _isSelectionMode = false;

  HistoryViewModel(this._transactionProvider) {
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

  List<TransactionModel> get archivedTransactions {
    final archived = _transactionProvider.archivedTransactions;

    final filtered = TransactionFilterUtils.filter(
      transactions: archived,
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

  void setIsIncomeFilter(bool? value) {
    _isIncomeFilter = value;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void toggleSelection(int key) {
    if (_selectedKeys.contains(key)) {
      _selectedKeys.remove(key);
      if (_selectedKeys.isEmpty) _isSelectionMode = false;
    } else {
      _selectedKeys.add(key);
      _isSelectionMode = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedKeys.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void selectAll() {
    _selectedKeys.addAll(archivedTransactions.map((tx) => tx.key as int));
    _isSelectionMode = true;
    notifyListeners();
  }

  void deselectAll() {
    clearSelection();
  }

  Future<void> deleteSelected() async {
    if (_selectedKeys.isEmpty) return;
    await _transactionProvider.deletePermanently(_selectedKeys.toList());
    clearSelection();
  }

  Future<void> restoreSelected() async {
    if (_selectedKeys.isEmpty) return;
    await _transactionProvider.restoreTransactions(_selectedKeys.toList());
    clearSelection();
  }

  Future<void> restoreSingle(int key) async {
    await _transactionProvider.restoreTransactions([key]);
    if (_selectedKeys.contains(key)) {
      _selectedKeys.remove(key);
      if (_selectedKeys.isEmpty) _isSelectionMode = false;
    }
    notifyListeners();
  }

  Future<void> restoreAll() async {
    await _transactionProvider.restoreAllTransactions();
    clearSelection();
  }
}
