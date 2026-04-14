import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/widgets/analytics/spending_category_breakdown.dart';
import 'package:montage/widgets/analytics/trends_weekly_breakdown.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:montage/widgets/analytics/trends_bar_chart.dart';
import '../providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

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
      appBar: const CustomAppBar(title: "Spending Analytics"),
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final summary = provider.spendingSummary;
          final weeklyData = provider.weeklyFinancialSummary;

          if (summary.categoryTotals.isEmpty) {
            return _buildEmptyState();
          }

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < -200 && _isPieChart) {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              } else if (details.primaryVelocity! > 200 && !_isPieChart) {
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              }
            },
            child: SingleChildScrollView(
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
                        TrendsBarChart(weeklyData: weeklyData),
                      ],
                    ),
                  ),
                  16.heightBox,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _isPieChart
                        ? SpendingCategoryBreakdown(
                            categoryTotals: summary.categoryTotals,
                            sortedCategories: summary.sortedCategories,
                            grandTotal: summary.grandTotal,
                          )
                        : TrendsWeeklyBreakdown(weeklyData: weeklyData),
                  ),
                  80.heightBox,
                ],
              ),
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
        padding: const EdgeInsets.all(4),
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
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withValues(alpha: 0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    width: 0.9,
                  )
                : null,
          ),
          child: Center(
            child: Text(label).labelLarge(
              color: isSelected
                  ? Colors.white
                  : AppColors.white.withValues(alpha: 0.4),
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
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.02),
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
      final color = context.read<CategoryProvider>().getCategoryColor(entry.key);
      final radius = isTouched ? 32.0 : 24.0;
      final double opacity = isTouched ? 1.0 : 0.85;

      return PieChartSectionData(
        color: color.withValues(alpha: opacity),
        value: entry.value,
        radius: radius,
        showTitle: false,
        badgeWidget: isTouched
            ? Container(
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
                  context.read<CategoryProvider>().getIconForCategory(entry.key),
                  color: Colors.white,
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
        color: Colors.white.withValues(alpha: 0.03),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
              color: Colors.white.withValues(alpha: 0.5),
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            Builder(
              builder: (context) {
                final amountRaw = CurrencyUtils.formatAmount(
                  grandTotal,
                  currency,
                );
                final hasSuffix = amountRaw.contains(RegExp(r'[A-Za-z]'));
                final amountText = hasSuffix
                    ? amountRaw
                    : amountRaw.split('.')[0];
                final fontSize = amountText.length >= 12 ? 19.0 : 25.0;
                return Text(
                  amountText,
                ).h2(color: Colors.white, fontSize: fontSize);
              },
            ),
          ],
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
