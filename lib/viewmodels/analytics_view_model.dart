import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:fl_chart/fl_chart.dart';

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

  // Getters
  bool get isPieChart => _isPieChart;
  int get touchedIndex => _touchedIndex;

  SpendingSummary get summary => _transactionProvider.spendingSummary;
  List<FinancialPeriodData> get weeklyData =>
      _transactionProvider.weeklyFinancialSummary;

  // Actions
  void setPage(int index) {
    _isPieChart = index == 0;
    notifyListeners();
  }

  void setTouchedIndex(int index) {
    _touchedIndex = index;
    notifyListeners();
  }

  // Transformers
  List<PieChartSectionData> buildPieChartSections(BuildContext context) {
    final totals = summary.categoryTotals;
    int i = 0;
    return totals.entries.map((entry) {
      final isTouched = i == _touchedIndex;
      i++;
      final color = _categoryProvider.getCategoryColor(entry.key);
      final radius = isTouched ? 26.0 : 22.0;
      final double opacity = isTouched ? 1.0 : 0.85;

      return PieChartSectionData(
        color: color.withValues(alpha: opacity),
        value: entry.value,
        radius: radius,
        showTitle: false,
        badgeWidget: isTouched ? _buildBadge(entry.key) : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  Widget _buildBadge(String category) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        _categoryProvider.getIconForCategory(category),
        color: Colors.white,
        size: 16,
      ),
    );
  }

  String formatAmount(double amount, String currency) {
    final raw = CurrencyUtils.formatAmount(amount, currency);
    final hasSuffix = raw.contains(RegExp(r'[A-Za-z]'));
    return hasSuffix ? raw : raw.split('.')[0];
  }
}
