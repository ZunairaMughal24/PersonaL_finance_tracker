import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';

class HistoryViewModel extends ChangeNotifier {
  final TransactionProvider _transactionProvider;

  String _searchQuery = "";
  DateTimeRange? _selectedDateRange;
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
  Set<int> get selectedKeys => _selectedKeys;
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selectedKeys.length;

  List<TransactionModel> get archivedTransactions {
    var archived = _transactionProvider.archivedTransactions;

    // Filter by date range
    if (_selectedDateRange != null) {
      archived = archived.where((tx) {
        final date = DateTime.tryParse(tx.date);
        if (date == null) return false;
        return date.isAfter(
              _selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return archived;

    return archived.where((tx) {
      return tx.title.toLowerCase().contains(query) ||
          tx.category.toLowerCase().contains(query);
    }).toList();
  }

  // Logic
  void updateSearch(String query) {
    _searchQuery = query;
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
