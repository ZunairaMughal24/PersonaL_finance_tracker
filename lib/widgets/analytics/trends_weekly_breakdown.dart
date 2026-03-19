import 'package:flutter/material.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/providers/user_settings_provider.dart';
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
                color: Colors.white.withValues(alpha: 0.7),
                weight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            GlassContainer(
              borderRadius: 24,
              blur: 40,
              borderOpacity: 0.12,
              gradientColors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
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
                            color: Colors.white.withValues(alpha: 0.04),
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
      padding: const EdgeInsets.only(left: 20, right: 16, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateUtilsCustom.getFullDayName(data.date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                          color: AppColors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.green.withValues(alpha: 0.2),
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
                            color: Colors.white.withValues(alpha: 0.6),
                            weight: FontWeight.w600,
                            fontSize: 14,
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
                        color: AppColors.primaryLight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
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
                          color: Colors.white.withValues(alpha: 0.6),
                          weight: FontWeight.w600,
                          fontSize: 14,
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
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.04)),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Net").labelLarge(
                  color: Colors.white.withValues(alpha: 0.6),
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
                      : AppColors.red.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

