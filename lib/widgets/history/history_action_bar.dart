import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';

class HistoryActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const HistoryActionBar({
    super.key,
    required this.selectedCount,
    required this.onRestore,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AppBottomSheetContainer(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        (bottomPadding > 0 ? bottomPadding : 24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selection Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$selectedCount items selected",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: onCancel,
                child: Text(
                  "Clear selection",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          24.heightBox,

          // Full-width Actions
          Row(
            children: [
              Expanded(
                child: _FullWidthActionButton(
                  icon: Icons.settings_backup_restore_rounded,
                  label: "Restore",
                  onTap: onRestore,
                  color: AppColors.primaryColor,
                ),
              ),
              16.widthBox,
              Expanded(
                child: _FullWidthActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: "Delete",
                  onTap: onDelete,
                  color: Colors.redAccent,
                  isDanger: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FullWidthActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isDanger;

  const _FullWidthActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDanger ? Colors.redAccent : color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              10.widthBox,
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
