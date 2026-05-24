import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/glass_container.dart';

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
    return AppBottomSheetContainer(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Text(
              "$selectedCount Selected",
            ).titleMedium(color: Colors.white, weight: FontWeight.w600),
          ),
          Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
            indent: 24,
            endIndent: 24,
          ),
          _buildMenuOption(
            icon: Icons.settings_backup_restore_rounded,
            title: "Restore",
            iconColor: AppColors.primaryColor,
            onTap: onRestore,
            showDivider: true,
          ),
          _buildMenuOption(
            icon: Icons.ios_share_rounded,
            title: "Export",
            iconColor: Colors.cyanAccent,
            onTap: onExport,
            showDivider: true,
          ),
          _buildMenuOption(
            icon: Icons.delete_outline_rounded,
            title: "Delete",
            iconColor: Colors.redAccent,
            onTap: onDelete,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                16.widthBox,
                Text(
                  title,
                ).bodyLarge(color: Colors.white, weight: FontWeight.w500),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
            indent: 24,
            endIndent: 24,
          ),
      ],
    );
  }
}
