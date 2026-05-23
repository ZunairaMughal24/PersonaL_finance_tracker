import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';

class ActivityFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color? activeColor;

  const ActivityFilterChip({
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
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        gradientColors: isSelected
            ? [
                effective.withValues(alpha: 0.3),
                effective.withValues(alpha: 0.1),
              ]
            : [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
        borderColor: isSelected
            ? effective.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.05),
        showShadow: false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? (activeColor ?? Colors.white)
                  : Colors.white70,
            ),
            8.widthBox,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
