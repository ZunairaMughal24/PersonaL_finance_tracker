import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_action_dialog.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDetail;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.currency,
    this.onDelete,
    this.onEdit,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final Color fillColor = AppColors.primaryColor.withOpacity(0.15);
    final Color borderColor = AppColors.primaryColor.withOpacity(0.2);

    final Color statusColor =
        (transaction.isIncome ? AppColors.green : AppColors.red).withOpacity(
          0.7,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: GlassContainer(
        borderRadius: 16,
        blur: 12,
        padding: EdgeInsets.zero,
        gradientColors: [
          Colors.white.withOpacity(0.12),
          AppColors.primaryColor.withOpacity(0.05),
          Colors.white.withOpacity(0.08),
        ],
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDetail,
            onLongPress: () => _showDialog(context),
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
                        Text(transaction.category).titleMedium(
                          color: AppColors.white,
                          weight: FontWeight.w600,
                        ),
                        if (transaction.title.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            transaction.title,
                          ).bodySmall(color: AppColors.white.withOpacity(0.7)),
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
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            child:
                                Text(
                                  CurrencyUtils.formatAmount(
                                    transaction.amount,
                                    transaction.currency,
                                  ),
                                ).mono(
                                  fontSize: 14,
                                  weight: FontWeight.w600,
                                  color: statusColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.date,
                      ).caption(color: AppColors.white.withOpacity(0.6)),
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => TransactionActionDialog(
        category: transaction.category,
        amount: transaction.amount,
        onEdit: () => onEdit?.call(),
        onDelete: () => onDelete?.call(),
      ),
    );
  }
}
