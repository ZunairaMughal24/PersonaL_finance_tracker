import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/app_colors.dart';
import 'package:personal_finance_tracker/core/themes/text_theme_extension.dart';
import 'package:personal_finance_tracker/core/utils/category_utils.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance_tracker/core/constants/app_images.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';

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

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: AppBackground(
        style: BackgroundStyle.detailSheet,
        child: GlassContainer(
          customBorderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
          blur: 20,
          showBottomBorder: false,
          showShadow: false,
          borderOpacity: 0.2,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          gradientColors: [
            Colors.white.withValues(alpha: 0.12),
            statusColor.withValues(alpha: 0.1),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              20.heightBox,

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
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
                textAlign: TextAlign.center,
              ).h2(color: Colors.white, weight: FontWeight.w700),
              2.heightBox,
              Text(transaction.isIncome ? "INCOME" : "EXPENSE").labelLarge(
                color: statusColor.withValues(alpha: 0.7),
                weight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
              8.heightBox,

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  CurrencyUtils.formatAmount(transaction.amount, currency),
                ).h1(color: statusColor, weight: FontWeight.w900, fontSize: 24),
              ),
              12.heightBox,

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      iconPath: AppImages.calendar,
                      label: "DATE",
                      value: transaction.date,
                    ),
                    if (transaction.title.isNotEmpty) ...[
                      Divider(
                        color: Colors.white.withValues(alpha: 0.07),
                        height: 20,
                      ),
                      _buildInfoRow(
                        icon: Icons.notes_rounded,
                        label: "NOTE",
                        value: transaction.title,
                        isMultiline: true,
                      ),
                    ],
                  ],
                ),
              ),

              24.heightBox,

              _CloseButton(onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    IconData? icon,
    String? iconPath,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (iconPath != null)
          SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.5),
              BlendMode.srcIn,
            ),
            height: 16,
          )
        else
          Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 17),
        10.widthBox,
        Text(label).labelLarge(
          color: Colors.white.withValues(alpha: 0.6),
          weight: FontWeight.w600,
          letterSpacing: 1.1,
          fontSize: 12,
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              Text(
                value,
                textAlign: TextAlign.right,
                maxLines: isMultiline ? null : 1,
              ).labelLarge(
                color: Colors.white.withValues(alpha: 0.9),
                weight: FontWeight.w600,
                fontSize: label == "DATE" ? 16 : 15,
              ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.9),
            AppColors.primaryColor.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: const Text("Close").labelLarge(
                color: Colors.white,
                weight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
