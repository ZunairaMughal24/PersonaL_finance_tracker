import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';

class TransactionActionDialog extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String category;
  final double amount;

  const TransactionActionDialog({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings_suggest_rounded,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(category).h2(color: Colors.white, weight: FontWeight.bold),
              const SizedBox(height: 4),
              Text(
                CurrencyUtils.formatAmount(amount, "USD"),
              ).bodyMedium(color: AppColors.white.withOpacity(0.6)),
              const SizedBox(height: 32),
              _buildActionButton(
                label: "Edit Transaction",
                icon: Icons.edit_rounded,
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                label: "Delete Transaction",
                icon: Icons.delete_outline_rounded,
                color: AppColors.red,
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel").labelLarge(
                  color: AppColors.white.withOpacity(0.4),
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 16),
              Text(label).labelLarge(color: color, weight: FontWeight.w600),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.white.withOpacity(0.2),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
