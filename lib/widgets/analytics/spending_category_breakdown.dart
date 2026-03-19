import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/category_utils.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:provider/provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/transaction/transaction_detail_sheet.dart';

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
            color: Colors.white.withValues(alpha: 0.7),
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

    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final categoryTransactions = provider.transactions
            .where((tx) => !tx.isIncome && tx.category == category)
            .toList();
        final latestTransaction = categoryTransactions.isNotEmpty
            ? categoryTransactions.last
            : null;

        return GlassContainer(
          borderRadius: 16,
          blur: 30,
          borderOpacity: 0.1,
          gradientColors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
          padding: EdgeInsets.zero,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (latestTransaction != null) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => TransactionDetailSheet(
                      transaction: latestTransaction,
                      currency: context
                          .read<UserSettingsProvider>()
                          .selectedCurrency,
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.1),
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).titleMedium(
                                color: AppColors.white,
                                weight: FontWeight.w600,
                              ),
                              if (latestTransaction != null &&
                                  latestTransaction.title.isNotEmpty)
                                Text(
                                  latestTransaction.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).bodySmall(
                                  color: AppColors.white.withValues(alpha: 0.5),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_downward_rounded,
                                  color: AppColors.red.withValues(alpha: 0.7),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Consumer<UserSettingsProvider>(
                                  builder: (context, settings, _) => FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child:
                                        Text(
                                          CurrencyUtils.formatAmount(
                                            amount,
                                            settings.selectedCurrency,
                                          ),
                                        ).mono(
                                          fontSize: 14,
                                          weight: FontWeight.w600,
                                          color: AppColors.red.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(percentage * 100).toStringAsFixed(1)}% of total',
                            ).labelMedium(
                              color: AppColors.white.withValues(alpha: 0.8),
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
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          height: 5,
                          width:
                              (MediaQuery.of(context).size.width - 44) *
                              percentage,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.5),
                                color.withValues(alpha: 0.9),
                                color,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
