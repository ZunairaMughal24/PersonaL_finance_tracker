import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class ActivityEmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback? onClearFilters;

  const ActivityEmptyState({
    super.key,
    this.hasFilters = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters
                    ? Icons.filter_list_off_rounded
                    : Icons.receipt_long_rounded,
                size: 50,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            24.heightBox,
            Text(
              hasFilters
                  ? "No transactions match your filters"
                  : "Your dashboard is clean",
              textAlign: TextAlign.center,
            ).h4(
              color: Colors.white.withValues(alpha: 0.8),
              weight: FontWeight.bold,
            ),
            8.heightBox,
            Text(
              hasFilters
                  ? "Try adjusting your filters or search query"
                  : "Add your first transaction to get started",
              textAlign: TextAlign.center,
            ).bodyLarge(color: Colors.white38),
            if (hasFilters && onClearFilters != null) ...[
              24.heightBox,
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text("Clear all filters"),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
