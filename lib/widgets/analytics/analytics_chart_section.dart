import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GlassContainer(
        borderRadius: 32,
        blur: 25,
        borderOpacity: 0.1,
        child: SizedBox(
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 6,
                  centerSpaceRadius: 90,
                  sections: _buildPieChartSections(categoryTotals),
                  startDegreeOffset: 270,
                ),
              ),
              _buildCenterText(grandTotal),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categoryTotals,
  ) {
    return categoryTotals.entries.map((entry) {
      final color = CategoryUtils.getCategoryColor(entry.key);
      return PieChartSectionData(
        color: color.withOpacity(0.9),
        value: entry.value,
        radius: 24,
        showTitle: false,
        badgeWidget: null,
      );
    }).toList();
  }

  Widget _buildCenterText(double grandTotal) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Spent").labelSmall(
              color: Colors.white.withOpacity(0.4),
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyUtils.formatAmount(grandTotal, "USD").split('.')[0],
            ).h2(color: Colors.white, fontSize: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> categoryTotals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GlassContainer(
        borderRadius: 32,
        blur: 25,
        borderOpacity: 0.1,
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: SizedBox(
          height: 320,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: categoryTotals.values.reduce((a, b) => a > b ? a : b) * 1.3,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black.withOpacity(0.8),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      CurrencyUtils.formatAmount(rod.toY, "USD"),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < categoryTotals.length) {
                        final cat = categoryTotals.keys.elementAt(
                          value.toInt(),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child:
                              Text(
                                cat.length > 5 ? cat.substring(0, 4) : cat,
                              ).labelSmall(
                                color: Colors.white.withOpacity(0.3),
                                weight: FontWeight.w600,
                              ),
                        );
                      }
                      return const SizedBox.shrink();
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
              barGroups: categoryTotals.entries.toList().asMap().entries.map((
                e,
              ) {
                final color = CategoryUtils.getCategoryColor(e.value.key);
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value,
                      color: color,
                      width: 22,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY:
                            categoryTotals.values.reduce(
                              (a, b) => a > b ? a : b,
                            ) *
                            1.3,
                        color: Colors.white.withOpacity(0.03),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
