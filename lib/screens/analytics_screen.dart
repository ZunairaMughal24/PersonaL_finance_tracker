import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/analytics/analytics_breakdown.dart';
import 'package:personal_finance_tracker/widgets/analytics/analytics_chart_section.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isPieChart = true;
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
    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: CustomAppBar(
        title: "Spending Analytics",
        onLeadingTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
      ),
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final summary = provider.spendingSummary;

          if (summary.categoryTotals.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              _buildToggle(),
              AnalyticsChartSection(
                categoryTotals: summary.categoryTotals,
                grandTotal: summary.grandTotal,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _isPieChart = index == 0;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      10.heightBox,
                      AnalyticsBreakdown(
                        categoryTotals: summary.categoryTotals,
                        sortedCategories: summary.sortedCategories,
                        grandTotal: summary.grandTotal,
                      ).px(16),
                      100.heightBox,
                    ],
                  ),
                ),
              ),
            ],
          ).safeArea();
        },
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GlassContainer(
        borderRadius: 12,
        blur: 10,
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(label).labelMedium(
              color: isSelected
                  ? Colors.white
                  : AppColors.white.withOpacity(0.5),
              weight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
