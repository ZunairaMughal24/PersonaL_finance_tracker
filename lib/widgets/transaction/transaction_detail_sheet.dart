import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/app_colors.dart';
import 'package:personal_finance_tracker/core/themes/text_theme_extension.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = transaction.isIncome ? AppColors.green : AppColors.red;
    final iconColor = CategoryUtils.getCategoryColor(transaction.category);

    return GlassContainer(
      borderRadius: 28,
      blur: 40,
      borderOpacity: 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      gradientColors: [
        Colors.white.withValues(alpha: 0.12),
        AppColors.primaryColor.withValues(alpha: 0.04),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          20.heightBox,

          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.15),
                      iconColor.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.15),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  CategoryUtils.getIconForCategory(transaction.category),
                  color: iconColor,
                  size: 32,
                ),
              ),
              12.heightBox,
              Text(
                transaction.category,
              ).h3(color: Colors.white, weight: FontWeight.w800),
            ],
          ),
          24.heightBox,

          Column(
            children: [
              Text("Total Amount").bodySmall(
                color: Colors.white.withValues(alpha: 0.35),
                weight: FontWeight.w700,
              ),
              4.heightBox,
              Text(
                CurrencyUtils.formatAmount(transaction.amount, currency),
              ).h1(color: statusColor, weight: FontWeight.w900, fontSize: 32),
            ],
          ),
          32.heightBox,

          _buildInfoRow(Icons.calendar_today_rounded, "DATE", transaction.date),
          _buildDivider(),
          _buildInfoRow(
            transaction.isIncome
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            "TYPE",
            transaction.isIncome ? "Income" : "Expense",
            color: statusColor,
          ),

          if (transaction.title.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoRow(
              Icons.notes_rounded,
              "NOTE",
              transaction.title,
              isLong: true,
            ),
          ],

          32.heightBox,

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.04),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Dismiss",
                  ).labelLarge(weight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
    bool isLong = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: isLong
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.3), size: 18),
          16.widthBox,
          Text(label).labelSmall(
            color: Colors.white.withValues(alpha: 0.4),
            weight: FontWeight.w800,
          ),
          const Spacer(),
          SizedBox(
            width: 180,
            child:
                Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: isLong ? 3 : 1,
                  overflow: TextOverflow.ellipsis,
                ).bodyLarge(
                  color: color ?? Colors.white.withValues(alpha: 0.9),
                  weight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.white.withValues(alpha: 0.05), thickness: 1),
    );
  }
}
