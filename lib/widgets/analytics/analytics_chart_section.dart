import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';

class AnalyticsChartSection extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double grandTotal;
  final PageController controller;
  final Function(int) onPageChanged;

  const AnalyticsChartSection({
    super.key,
    required this.categoryTotals,
    required this.grandTotal,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: PageView(
        controller: controller,
        onPageChanged: onPageChanged,
        children: [
          _buildPieChart(categoryTotals, grandTotal),
          _buildBarChart(categoryTotals),
        ],
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals, double grandTotal) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 110,
              sections: _buildPieChartSections(categoryTotals),
            ),
          ),
          _buildCenterText(grandTotal),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categoryTotals,
  ) {
    return categoryTotals.entries.map((entry) {
      final color = CategoryUtils.getCategoryColor(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        radius: 30,
        showTitle: false,
      );
    }).toList();
  }

  Widget _buildCenterText(double grandTotal) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Total Spent",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyUtils.formatAmount(grandTotal, "USD"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> categoryTotals) {
    return Container(
      height: 350,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: categoryTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < categoryTotals.length) {
                    final cat = categoryTotals.keys.elementAt(value.toInt());
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        cat.length > 3 ? cat.substring(0, 3) : cat,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: categoryTotals.entries.toList().asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.value,
                  color: CategoryUtils.getCategoryColor(e.value.key),
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY:
                        categoryTotals.values.reduce((a, b) => a > b ? a : b) *
                        1.2,
                    color: AppColors.surfaceLight.withOpacity(0.5),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
