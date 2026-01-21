import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/models/trends_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:provider/provider.dart';

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
    final provider = Provider.of<TransactionProvider>(context);

    final weeklyData = provider.weeklyFinancialSummary;
    return SizedBox(
      height: 310,
      child: PageView(
        controller: controller,
        onPageChanged: onPageChanged,
        children: [
          _buildPieChart(categoryTotals, grandTotal),
          _buildBarChart(weeklyData),
        ],
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals, double grandTotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassContainer(
        borderRadius: 24,
        blur: 30,
        borderOpacity: 0.1,
        gradientColors: [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.02),
        ],
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 6,
                centerSpaceRadius: 80,
                sections: _buildPieChartSections(categoryTotals),
                startDegreeOffset: 270,
              ),
            ),
            _buildCenterText(grandTotal),
          ],
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
      width: 120,
      height: 120,
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

  Widget _buildBarChart(List<FinancialPeriodData> weeklyData) {
    double maxVal = 0;
    for (var data in weeklyData) {
      if (data.income > maxVal) maxVal = data.income;
      if (data.expense > maxVal) maxVal = data.expense;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassContainer(
        borderRadius: 24,
        blur: 30,
        gradientColors: [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.02),
        ],
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVal * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black.withOpacity(0.9),
                  tooltipRoundedRadius: 8,

                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      CurrencyUtils.formatAmount(rod.toY, "USD"),
                      TextStyle(
                        color: rodIndex == 0
                            ? Colors.greenAccent
                            : Colors.redAccent,
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
                          value.toInt() < weeklyData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            weeklyData[value.toInt()].label,
                          ).labelSmall(color: Colors.white.withOpacity(0.5)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
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

              barGroups: weeklyData.asMap().entries.map((entry) {
                int index = entry.key;
                FinancialPeriodData data = entry.value;

                return BarChartGroupData(
                  x: index,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: data.income,
                      color: AppColors.primaryDark.withOpacity(0.8),
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),

                    BarChartRodData(
                      toY: data.expense,
                      color: AppColors.primaryLight,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
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
