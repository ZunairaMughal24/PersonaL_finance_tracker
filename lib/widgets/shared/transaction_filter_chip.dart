import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';

class TransactionFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color? activeColor;

  const TransactionFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effective = activeColor ?? AppColors.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        gradientColors: isSelected
            ? [
                effective.withValues(alpha: 0.4),
                effective.withValues(alpha: 0.2),
              ]
            : [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
        borderColor: isSelected
            ? effective.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.1),
        showShadow: false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (activeColor ?? Colors.white)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            6.widthBox,
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
