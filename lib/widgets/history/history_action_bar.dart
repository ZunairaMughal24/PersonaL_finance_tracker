import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/app_button.dart';

class HistoryActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onRestore;
  final VoidCallback onExport;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const HistoryActionBar({
    super.key,
    required this.selectedCount,
    required this.onRestore,
    required this.onExport,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AppBottomSheetContainer(
      padding: EdgeInsets.fromLTRB(24, 20, 24, (bottomPadding.clamp(12, 16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selection Info
          Text(
            "$selectedCount Items Selected",
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          20.heightBox,

          // Restore (Primary Action)
          AppButton(
            icon: const Icon(
              Icons.settings_backup_restore_rounded,
              color: Colors.white,
              size: 20,
            ),
            text: "Restore Transactions",
            onPressed: onRestore,
            color: AppColors.primaryColor,
            height: 45,
            borderRadius: 16,
          ),
          10.heightBox,

          // Export (Secondary Action)
          AppButton(
            icon: const Icon(
              Icons.ios_share_rounded,
              color: Colors.cyanAccent,
              size: 18,
            ),
            text: "Export Items",
            onPressed: onExport,
            color: Colors.cyanAccent.withValues(alpha: 0.1),
            borderColor: Colors.cyanAccent.withValues(alpha: 0.2),
            textColor: Colors.cyanAccent,
            height: 45,
            borderRadius: 16,
          ),
          10.heightBox,

          // Delete (Destructive Action)
          AppButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 18,
            ),
            text: "Delete History",
            onPressed: onDelete,
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderColor: Colors.redAccent.withValues(alpha: 0.2),
            textColor: Colors.redAccent,
            height: 45,
            borderRadius: 16,
          ),
          4.heightBox,
        ],
      ),
    );
  }
}
