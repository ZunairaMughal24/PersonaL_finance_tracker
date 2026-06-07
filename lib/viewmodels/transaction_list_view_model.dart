import 'package:flutter/material.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/core/utils/transaction_filter_utils.dart';

class TransactionListViewModel extends ChangeNotifier {
  final TransactionProvider _transactionProvider;
  final bool isHistoryMode;
  final bool isArchiveMode;

  String _searchQuery = "";
  DateTimeRange? _selectedDateRange;
  String? _selectedCategory;
  bool? _isIncomeFilter;
  final Set<int> _selectedIds = {};
  bool _isSelectionMode = false;
  bool _isSearchVisible = false;

  TransactionListViewModel(
    this._transactionProvider, {
    required this.isHistoryMode,
    this.isArchiveMode = false,
  }) {
    _transactionProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _transactionProvider.removeListener(notifyListeners);
    super.dispose();
  }

  String get searchQuery => _searchQuery;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedCategory => _selectedCategory;
  bool? get isIncomeFilter => _isIncomeFilter;
  Set<int> get selectedIds => _selectedIds;
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selectedIds.length;
  bool get isSearchVisible => _isSearchVisible;

  List<Transaction> get filteredTransactions {
    final baseTransactions = isHistoryMode
        ? _transactionProvider.deletedTransactions
        : isArchiveMode
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

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchVisible = !_isSearchVisible;
    if (!_isSearchVisible) _searchQuery = "";
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
    if (!_isSelectionMode) _selectedIds.clear();
    notifyListeners();
  }

  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    } else {
      _selectedIds.add(id);
      _isSelectionMode = true;
    }
    notifyListeners();
  }

  void selectAll([List<int>? ids]) {
    final targets = ids ?? filteredTransactions.map((tx) => tx.id!).toList();
    _selectedIds.addAll(targets);
    _isSelectionMode = true;
    notifyListeners();
  }

  void deselectAll() {
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  void clearSelection() => deselectAll();

  Future<void> deleteSelected() async {
    await _transactionProvider.deletePermanently(_selectedIds.toList());
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> archiveSelected() async {
    await _transactionProvider.archiveTransactions(_selectedIds.toList());
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> archiveAll() async {
    selectAll();
    await archiveSelected();
  }

  Future<void> restoreSelected() async {
    await _transactionProvider.restoreTransactions(_selectedIds.toList());
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> restoreAll() async {
    await _transactionProvider.restoreAllTransactions();
    notifyListeners();
  }

  Future<void> moveSelectedToHistory() async {
    for (final id in _selectedIds.toList()) {
      await _transactionProvider.deleteTransaction(id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> deleteSingleTransaction(int id) async {
    await _transactionProvider.deleteTransaction(id);
    notifyListeners();
  }

  Future<void> deleteSinglePermanently(int id) async {
    await _transactionProvider.deletePermanently([id]);
    notifyListeners();
  }

  Future<void> restoreSingleTransaction(int id) async {
    await _transactionProvider.restoreTransactions([id]);
    notifyListeners();
  }

  Future<void> archiveSingleTransaction(int id) async {
    await _transactionProvider.archiveTransaction(id);
    notifyListeners();
  }
}
