import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/app_button.dart';

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
          Text(
            "$selectedCount Items Selected",
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          8.heightBox,
          Text(
            "What would you like to do with these transactions?",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.6)),
          32.heightBox,

          Row(
            children: [
              Expanded(
                child: AppButton(
                  icon: const Icon(
                    Icons.settings_backup_restore_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  text: "Restore",
                  onPressed: onRestore,
                  color: AppColors.primaryColor,
                  height: 45,
                ),
              ),
              16.widthBox,
              Expanded(
                child: AppButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  text: "Delete",
                  onPressed: onDelete,
                  color: Colors.redAccent,
                  height: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
