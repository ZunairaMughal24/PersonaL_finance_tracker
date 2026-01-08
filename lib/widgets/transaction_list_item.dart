import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/widgets/transaction_action_dialog.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDetail;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.index,
    this.onDelete,
    this.onEdit,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = AppColors.primaryColor;
    final Color iconColor = transaction.isIncome
        ? AppColors.green
        : AppColors.red;

    final double baseOpacity = 0.25;
    final double depthStep = 0.04;
    final double currentOpacity = (baseOpacity - (index * depthStep)).clamp(
      0.08,
      0.3,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDetail,
        onLongPress: () => _showClassyDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: baseColor.withOpacity(currentOpacity),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: baseColor.withOpacity(currentOpacity + 0.1),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(transaction.category),
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (transaction.title.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        color: transaction.isIncome
                            ? AppColors.green
                            : AppColors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.35,
                        ),
                        child: Text(
                          CurrencyUtils.formatAmount(
                            transaction.amount,
                            transaction.currency,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: transaction.isIncome
                                ? AppColors.green
                                : AppColors.red,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClassyDialog(BuildContext context) {
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
