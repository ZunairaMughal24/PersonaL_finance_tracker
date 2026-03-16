import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/app_colors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/text_theme_extension.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance_tracker/core/constants/app_images.dart';

class TransactionActionDialog extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDetail;
  final String category;
  final double amount;
  final String currency;

  const TransactionActionDialog({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onDetail,
    required this.category,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: GlassContainer(
          borderRadius: 28,
          blur: 25,
          borderOpacity: 0.1,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
              const SizedBox(height: 20),

              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withValues(alpha: 0.4),
                          AppColors.primaryColor.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.15),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_suggest_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                category,
                textAlign: TextAlign.center,
              ).h3(color: Colors.white, weight: FontWeight.w800),
              const SizedBox(height: 4),
              Text(
                CurrencyUtils.formatAmount(amount, currency),
                textAlign: TextAlign.center,
              ).mono(
                color: AppColors.white.withValues(alpha: 0.5),
                fontSize: 15,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 24),

              _buildActionButton(
                label: "View Details",
                icon: Icons.info_outline_rounded,
                color: AppColors.primaryColor,
                gradientColors: [
                  AppColors.primaryColor.withValues(alpha: 0.12),
                  AppColors.primaryColor.withValues(alpha: 0.04),
                ],
                onPressed: () {
                  Navigator.pop(context);
                  onDetail();
                },
              ),
              const SizedBox(height: 10),

              _buildActionButton(
                label: "Edit Transaction",
                icon: Icons.edit_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                gradientColors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.03),
                ],
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                label: "Delete Transaction",
                iconPath: AppImages.trashBin,
                color: AppColors.red.withValues(alpha: 0.85),
                gradientColors: [
                  AppColors.red.withValues(alpha: 0.12),
                  AppColors.red.withValues(alpha: 0.04),
                ],
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  child: Text("Cancel").caption(
                    color: AppColors.white.withValues(alpha: 0.35),
                    weight: FontWeight.w600,
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
    IconData? icon,
    String? iconPath,
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        height: 20,
                      )
                    : Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                label,
              ).labelLarge(color: color, weight: FontWeight.w600, fontSize: 16),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
