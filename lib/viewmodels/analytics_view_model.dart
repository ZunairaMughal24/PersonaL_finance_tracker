import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final TransactionProvider _transactionProvider;
  final CategoryProvider _categoryProvider;

  bool _isPieChart = true;
  int _touchedIndex = -1;

  AnalyticsViewModel(this._transactionProvider, this._categoryProvider) {
    _transactionProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _transactionProvider.removeListener(notifyListeners);
    super.dispose();
  }

  // ── Getters
  bool get isPieChart => _isPieChart;
  int get touchedIndex => _touchedIndex;
  CategoryProvider get categoryProvider => _categoryProvider;

  SpendingSummary get summary => _transactionProvider.spendingSummary;
  List<FinancialPeriodData> get weeklyData =>
      _transactionProvider.weeklyFinancialSummary;

  // ── Actions
  void setPage(int index) {
    _isPieChart = index == 0;
    notifyListeners();
  }

  void setTouchedIndex(int index) {
    _touchedIndex = index;
    notifyListeners();
  }

  //  The category currently touched (null if none).
  String? get touchedCategory {
    if (_touchedIndex < 0) return null;
    final keys = summary.categoryTotals.keys.toList();
    if (_touchedIndex >= keys.length) return null;
    return keys[_touchedIndex];
  }

  // Formatters
  String formatAmount(double amount, String currency) {
    final raw = CurrencyUtils.formatAmount(amount, currency);
    final hasSuffix = raw.contains(RegExp(r'[A-Za-z]'));
    return hasSuffix ? raw : raw.split('.')[0];
  }
}
