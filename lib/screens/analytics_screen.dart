import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/analytics/spending_category_breakdown.dart';
import 'package:personal_finance_tracker/widgets/analytics/trends_daily_breakdown.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:personal_finance_tracker/models/trends_model.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isPieChart = true;
  late PageController _pageController;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.abstractDark,
      appBar: CustomAppBar(
        title: "Spending Analytics",
        onLeadingTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
      ),
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final summary = provider.spendingSummary;
          final weeklyData = provider.weeklyFinancialSummary;

          if (summary.categoryTotals.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.heightBox,
                _buildToggle(),
                8.heightBox,
                SizedBox(
                  height: 310,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _isPieChart = index == 0;
                      });
                    },
                    children: [
                      _buildPieChart(
                        summary.categoryTotals,
                        summary.grandTotal,
                      ),
                      _buildBarChart(weeklyData),
                    ],
                  ),
                ),
                16.heightBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isPieChart
                      ? SpendingCategoryBreakdown(
                          categoryTotals: summary.categoryTotals,
                          sortedCategories: summary.sortedCategories,
                          grandTotal: summary.grandTotal,
                        )
                      : TrendsDailyBreakdown(weeklyData: weeklyData),
                ),
                80.heightBox,
              ],
            ),
          ).safeArea();
        },
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GlassContainer(
        borderRadius: 16,
        blur: 15,
        borderOpacity: 0.1,
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _toggleItem("Spendings", _isPieChart, 0),
            _toggleItem("Trends", !_isPieChart, 1),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String label, bool isSelected, int page) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.white.withOpacity(0.1), width: 0.5)
                : null,
          ),
          child: Center(
            child: Text(label).labelLarge(
              color: isSelected
                  ? Colors.white
                  : AppColors.white.withOpacity(0.4),
              weight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals, double grandTotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
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
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 6,
                centerSpaceRadius: 100,
                sections: _buildPieChartSections(categoryTotals),
                startDegreeOffset: 270,
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
            Consumer<UserSettingsProvider>(
              builder: (context, settings, _) =>
                  _buildCenterText(grandTotal, settings.selectedCurrency),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categoryTotals,
  ) {
    int i = 0;
    return categoryTotals.entries.map((entry) {
      final isTouched = i == _touchedIndex;
      i++;
      final color = CategoryUtils.getCategoryColor(entry.key);
      final radius = isTouched ? 32.0 : 24.0;
      final double opacity = isTouched ? 1.0 : 0.85;

      return PieChartSectionData(
        color: color.withOpacity(opacity),
        value: entry.value,
        radius: radius,
        showTitle: false,
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(entry.key),
                  color: color,
                  size: 16,
                ),
              )
            : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  Widget _buildCenterText(double grandTotal, String currency) {
    return Container(
      width: 170,
      height: 170,
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
            Text("Total Spent").bodyMedium(
              color: Colors.white.withOpacity(0.5),
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyUtils.formatAmount(grandTotal, currency).split('.')[0],
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
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      child: GlassContainer(
        borderRadius: 24,
        blur: 30,
        gradientColors: [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.04),
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
                          ).labelMedium(color: Colors.white.withOpacity(0.5)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(CurrencyUtils.formatCompactAmount(value))
                            .labelMedium(
                              color: Colors.white.withOpacity(0.4),
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
                horizontalInterval: (maxVal * 1.2) / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.05),
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
                      color: AppColors.green.withOpacity(0.8),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics_outlined, size: 64, color: Colors.white10),
          20.heightBox,
          const Text("No data to display").bodyMedium(color: Colors.white30),
        ],
      ),
    );
  }
}
