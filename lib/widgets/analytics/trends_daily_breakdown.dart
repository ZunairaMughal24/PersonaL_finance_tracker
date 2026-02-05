import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/models/trends_model.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class TrendsDailyBreakdown extends StatelessWidget {
  final List<FinancialPeriodData> weeklyData;

  const TrendsDailyBreakdown({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    final filteredData = weeklyData
        .where((data) => data.income > 0 || data.expense > 0)
        .toList();

    if (filteredData.isEmpty) {
      return SizedBox.shrink();
    }

    return Consumer<UserSettingsProvider>(
      builder: (context, settings, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text("WEEKLY BREAKDOWN").labelLarge(
                color: Colors.white.withOpacity(0.7),
                weight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            GlassContainer(
              borderRadius: 24,
              blur: 40,
              borderOpacity: 0.12,
              gradientColors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: filteredData.asMap().entries.map((entry) {
                  final isLast = entry.key == filteredData.length - 1;
                  final data = entry.value;
                  return Column(
                    children: [
                      _buildDayBreakdownItem(
                        context,
                        data,
                        settings.selectedCurrency,
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDayBreakdownItem(
    BuildContext context,
    FinancialPeriodData data,
    String currency,
  ) {
    final hasIncome = data.income > 0;
    final hasExpense = data.expense > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.label,
              ).titleLarge(color: Colors.white, weight: FontWeight.w700),
            ],
          ),
          12.heightBox,

          if (hasIncome)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.green.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColors.green,
                          size: 16,
                        ),
                      ),
                      12.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Income").labelLarge(
                            color: Colors.white.withOpacity(0.5),
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(CurrencyUtils.formatAmount(data.income, currency)).mono(
                    weight: FontWeight.bold,
                    fontSize: 17,
                    color: AppColors.green,
                  ),
                ],
              ),
            ),
          if (hasExpense)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryLight.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.primaryLight,
                        size: 16,
                      ),
                    ),
                    12.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expense").labelLarge(
                          color: Colors.white.withOpacity(0.5),
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(CurrencyUtils.formatAmount(data.expense, currency)).mono(
                  weight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.primaryLight,
                ),
              ],
            ),
          if (hasIncome && hasExpense) ...[
            8.heightBox,
            Divider(height: 1, color: Colors.white.withOpacity(0.04)),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Net").labelLarge(
                  color: Colors.white.withOpacity(0.6),
                  weight: FontWeight.w700,
                ),
                Text(
                  CurrencyUtils.formatAmount(
                    data.income - data.expense,
                    currency,
                  ),
                ).mono(
                  weight: FontWeight.bold,
                  fontSize: 14,
                  color: (data.income - data.expense) >= 0
                      ? AppColors.green
                      : AppColors.primaryLight,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
