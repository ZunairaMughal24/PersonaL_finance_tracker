import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/category_provider.dart';
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
import 'package:montage/widgets/shared/transaction_section_header.dart';
import 'package:montage/viewmodels/analytics_view_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnalyticsViewModel(
        context.read<TransactionProvider>(),
        context.read<CategoryProvider>(),
      ),
      child: const _AnalyticsScreenContent(),
    );
  }
}

class _AnalyticsScreenContent extends StatefulWidget {
  const _AnalyticsScreenContent();

  @override
  State<_AnalyticsScreenContent> createState() =>
      _AnalyticsScreenContentState();
}

class _AnalyticsScreenContentState extends State<_AnalyticsScreenContent> {
  late PageController _pageController;

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
    final vm = context.watch<AnalyticsViewModel>();

    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: const CustomAppBar(title: "Spending Analytics"),
      child: vm.summary.categoryTotals.isEmpty
          ? _buildEmptyState()
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! < -200 && vm.isPieChart) {
                  _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                  );
                } else if (details.primaryVelocity! > 200 && !vm.isPieChart) {
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
                    10.heightBox,
                    const TransactionSectionHeader(
                      title: "VISUAL DATA",
                      subtitle: "Comparison of spending vs trends",
                    ),
                    _buildToggle(vm),
                    8.heightBox,
                    SizedBox(
                      height: 310,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: vm.setPage,
                        children: [
                          _buildPieChart(context, vm),
                          TrendsBarChart(weeklyData: vm.weeklyData),
                        ],
                      ),
                    ),
                    10.heightBox,
                    TransactionSectionHeader(
                      title: vm.isPieChart
                          ? "DATA DISTRIBUTION"
                          : "WEEKLY PERFORMANCE",
                      subtitle: vm.isPieChart
                          ? "Spending by category"
                          : "Historical trend analysis",
                    ),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: vm.isPieChart
                          ? SpendingCategoryBreakdown(
                              categoryTotals: vm.summary.categoryTotals,
                              sortedCategories: vm.summary.sortedCategories,
                              grandTotal: vm.summary.grandTotal,
                            )
                          : TrendsWeeklyBreakdown(weeklyData: vm.weeklyData),
                    ),
                    80.heightBox,
                  ],
                ),
              ),
            ).safeArea(),
    );
  }

  Widget _buildToggle(AnalyticsViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GlassContainer(
        borderRadius: 16,
        blur: 15,
        borderOpacity: 0.1,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _toggleItem("Spendings", vm.isPieChart, 0, vm),
            _toggleItem("Trends", !vm.isPieChart, 1, vm),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(
    String label,
    bool isSelected,
    int page,
    AnalyticsViewModel vm,
  ) {
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

  Widget _buildPieChart(BuildContext context, AnalyticsViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      child: GlassContainer(
        borderRadius: 24,
        blur: 40,
        borderOpacity: 0.18,
        gradientColors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.03),
        ],
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.12),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      vm.setTouchedIndex(-1);
                      return;
                    }
                    vm.setTouchedIndex(
                      pieTouchResponse.touchedSection!.touchedSectionIndex,
                    );
                  },
                ),
                sectionsSpace: 6,
                centerSpaceRadius: 105,
                sections: _buildPieChartSections(vm),
                startDegreeOffset: 270,
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
            Consumer<UserSettingsProvider>(
              builder: (context, settings, _) =>
                  _buildCenterText(vm, settings.selectedCurrency),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterText(AnalyticsViewModel vm, String currency) {
    return Container(
      width: 175,
      height: 175,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
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
            Text(vm.formatAmount(vm.summary.grandTotal, currency)).h2(
              color: Colors.white,
              fontSize:
                  vm.formatAmount(vm.summary.grandTotal, currency).length >= 12
                  ? 19.0
                  : 25.0,
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

  List<PieChartSectionData> _buildPieChartSections(AnalyticsViewModel vm) {
    final totals = vm.summary.categoryTotals;
    int i = 0;
    return totals.entries.map((entry) {
      final isTouched = i == vm.touchedIndex;
      i++;
      final color = vm.categoryProvider.getCategoryColor(entry.key);
      final radius = isTouched ? 26.0 : 22.0;
      final double opacity = isTouched ? 1.0 : 0.85;

      return PieChartSectionData(
        color: color.withValues(alpha: opacity),
        value: entry.value,
        radius: radius,
        showTitle: false,
        badgeWidget: isTouched ? _buildBadge(entry.key, vm) : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  // Built here in the UI layer (not in the VM) — badge widget for touched pie slice
  Widget _buildBadge(String category, AnalyticsViewModel vm) {
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
        vm.categoryProvider.getIconForCategory(category),
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
