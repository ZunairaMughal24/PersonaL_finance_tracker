import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_button.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final IconData? icon;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
    this.confirmColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassContainer(
        borderRadius: 28,
        blur: 35,
        borderOpacity: 0.15,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (confirmColor ?? AppColors.primaryColor).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: confirmColor ?? AppColors.primaryColor,
                  size: 32,
                ),
              ),
              20.heightBox,
            ],
            Text(
              title,
              textAlign: TextAlign.center,
            ).h4(color: Colors.white, weight: FontWeight.bold),
            12.heightBox,
            Text(
              description,
              textAlign: TextAlign.center,
            ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
            32.heightBox,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Cancel",
                    color: Colors.white.withValues(alpha: 0.05),
                    textColor: Colors.white70,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                16.widthBox,
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    color: confirmColor ?? AppColors.primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
