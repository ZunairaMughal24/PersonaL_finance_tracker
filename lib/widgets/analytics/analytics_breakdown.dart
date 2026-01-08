import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';

class AnalyticsBreakdown extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double grandTotal;
  final List<dynamic> transactions;

  const AnalyticsBreakdown({
    super.key,
    required this.categoryTotals,
    required this.grandTotal,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final expenses = transactions.where((t) => !t.isIncome).toList();
    final categoriesByRecency = <String>[];

    for (var tx in expenses.reversed) {
      if (!categoriesByRecency.contains(tx.category) &&
          categoryTotals.containsKey(tx.category)) {
        categoriesByRecency.add(tx.category);
      }
    }

    for (var cat in categoryTotals.keys) {
      if (!categoriesByRecency.contains(cat)) {
        categoriesByRecency.add(cat);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Breakdown",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...categoriesByRecency.map((category) {
            return _buildLegendItem(
              context,
              category,
              categoryTotals[category]!,
              grandTotal,
            );
          }),
        ],
      ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.2), width: 1),
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(category),
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                CurrencyUtils.formatAmount(amount, "USD"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 6,
                width: (MediaQuery.of(context).size.width - 50) * percentage,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
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
