import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

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
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: GlassContainer(
          borderRadius: 32,
          blur: 25,
          borderOpacity: 0.1,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull handle-like indicator for modern feel
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Icon Cluster
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.5),
                          AppColors.primaryColor.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_suggest_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                category,
              ).h2(color: Colors.white, weight: FontWeight.bold, fontSize: 22),
              const SizedBox(height: 4),
              Text(CurrencyUtils.formatAmount(amount, "USD")).mono(
                color: AppColors.white.withOpacity(0.6),
                fontSize: 16,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 32),

              _buildActionButton(
                label: "Edit Transaction",
                icon: Icons.edit_rounded,
                color: Colors.white,
                gradientColors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                label: "Delete Transaction",
                icon: Icons.delete_outline_rounded,
                color: AppColors.red.withOpacity(0.9),
                gradientColors: [
                  AppColors.red.withOpacity(0.15),
                  AppColors.red.withOpacity(0.05),
                ],
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text("Cancel").h4(
                    color: AppColors.white.withOpacity(0.4),
                    weight: FontWeight.w600,
                    // letterSpacing: 1.2,
                  ),
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
    required List<Color> gradientColors,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                label,
              ).labelLarge(color: color, weight: FontWeight.w600, fontSize: 16),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withOpacity(0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
