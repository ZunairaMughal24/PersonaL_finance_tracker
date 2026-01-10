import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';

class AnalyticsBreakdown extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final List<String> sortedCategories;
  final double grandTotal;

  const AnalyticsBreakdown({
    super.key,
    required this.categoryTotals,
    required this.sortedCategories,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text("BREAKDOWN").labelLarge(
            color: Colors.white.withOpacity(0.4),
            weight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: 28,
          blur: 20,
          borderOpacity: 0.1,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: sortedCategories.asMap().entries.map((entry) {
              final isLast = entry.key == sortedCategories.length - 1;
              return Column(
                children: [
                  _buildLegendItem(
                    context,
                    entry.value,
                    categoryTotals[entry.value]!,
                    grandTotal,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.05),
                      indent: 70,
                      endIndent: 20,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String category,
    double amount,
    double grandTotal,
  ) {
    final color = CategoryUtils.getCategoryColor(category);
    final percentage = (amount / grandTotal);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.15), width: 1),
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(category),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                    ).titleMedium(color: Colors.white, weight: FontWeight.w700),
                    const SizedBox(height: 1),
                    Text(
                      '${(percentage * 100).toStringAsFixed(1)}% of total',
                    ).labelSmall(
                      color: Colors.white.withOpacity(0.3),
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Text(CurrencyUtils.formatAmount(amount, "USD")).mono(
                weight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Premium Progress Pill
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                height: 6,
                width: (MediaQuery.of(context).size.width - 80) * percentage,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.6), color],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ).px(4),
        ],
      ),
    );
  }
}
