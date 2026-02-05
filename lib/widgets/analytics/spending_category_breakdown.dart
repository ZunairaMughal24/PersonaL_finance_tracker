import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class SpendingCategoryBreakdown extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final List<String> sortedCategories;
  final double grandTotal;

  const SpendingCategoryBreakdown({
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
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text("BREAKDOWN").labelLarge(
            color: Colors.white.withOpacity(0.7),
            weight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        Column(
          children: sortedCategories.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildCategoryItem(
                context,
                entry.value,
                categoryTotals[entry.value]!,
                grandTotal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String category,
    double amount,
    double grandTotal,
  ) {
    final color = CategoryUtils.getCategoryColor(category);
    final percentage = (amount / grandTotal);

    return GlassContainer(
      borderRadius: 16,
      blur: 30,
      borderOpacity: 0.1,
      gradientColors: [
        Colors.white.withOpacity(0.06),
        Colors.white.withOpacity(0.02),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(category),
                  color: color,
                  size: 18,
                ),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                    ).bodyLarge(color: Colors.white, weight: FontWeight.w600),
                    Text(
                      '${(percentage * 100).toStringAsFixed(1)}% of total',
                    ).labelMedium(
                      color: Colors.white.withOpacity(0.4),
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(CurrencyUtils.formatAmount(amount, "USD")).mono(
                    weight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          10.heightBox,
          Stack(
            children: [
              Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                height: 5,
                width: (MediaQuery.of(context).size.width - 48) * percentage,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.5),
                      color.withOpacity(0.9),
                      color,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
