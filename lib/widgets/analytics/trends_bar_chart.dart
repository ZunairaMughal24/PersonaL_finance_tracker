import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/chart_utils.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';

class TrendsBarChart extends StatelessWidget {
  final List<FinancialPeriodData> weeklyData;

  const TrendsBarChart({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    double maxVal = 0;
    for (var data in weeklyData) {
      if (data.income > maxVal) maxVal = data.income;
      if (data.expense > maxVal) maxVal = data.expense;
    }

    final axisConfig = ChartUtils.getNiceAxisConfig(maxVal);
    final maxY = axisConfig.maxY;
    final interval = axisConfig.interval;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      child: GlassContainer(
        borderRadius: 24,
        blur: 30,
        gradientColors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.04),
        ],
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black.withValues(alpha: 0.9),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final settings = Provider.of<UserSettingsProvider>(
                      context,
                      listen: false,
                    );
                    return BarTooltipItem(
                      CurrencyUtils.formatAmountCompact(
                        rod.toY,
                        settings.selectedCurrency,
                      ),
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
                          child: Text(weeklyData[value.toInt()].label)
                              .labelMedium(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(CurrencyUtils.formatCompactAmount(value))
                            .labelSmall(
                              color: Colors.white.withValues(alpha: 0.6),
                              weight: FontWeight.bold,
                            ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  );
                },
              ),
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
                      color: AppColors.green.withValues(alpha: 0.8),
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
