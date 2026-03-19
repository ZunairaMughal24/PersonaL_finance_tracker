import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/core/utils/category_utils.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/widgets/transaction/transaction_action_dialog.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/widgets/glass_container.dart';

import 'package:montage/widgets/transaction/transaction_detail_sheet.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.currency,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final Color fillColor = AppColors.primaryColor.withValues(alpha: 0.15);
    final Color borderColor = AppColors.primaryColor.withValues(alpha: 0.2);

    final Color statusColor =
        (transaction.isIncome ? AppColors.green : AppColors.red).withValues(
          alpha: 0.8,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GlassContainer(
        borderRadius: 16,
        blur: 12,
        padding: EdgeInsets.zero,
        gradientColors: [
          Colors.white.withValues(alpha: 0.12),
          AppColors.primaryColor.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.08),
        ],
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showDetailSheet(context),
            onLongPress: () => _showActionDialog(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: fillColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Icon(
                      CategoryUtils.getIconForCategory(transaction.category),
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ).titleMedium(
                          color: AppColors.white,
                          weight: FontWeight.w600,
                        ),
                        if (transaction.title.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            transaction.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).bodySmall(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            transaction.isIncome
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: statusColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child:
                                  Text(
                                    CurrencyUtils.formatAmount(
                                      transaction.amount,
                                      currency,
                                    ),
                                  ).mono(
                                    fontSize: 14,
                                    weight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(transaction.date).labelMedium(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          TransactionDetailSheet(transaction: transaction, currency: currency),
    );
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => TransactionActionDialog(
        category: transaction.category,
        amount: transaction.amount,
        onEdit: () => onEdit?.call(),
        onDelete: () => onDelete?.call(),
        onDetail: () => _showDetailSheet(context),
        currency: currency,
      ),
    );
  }
}
