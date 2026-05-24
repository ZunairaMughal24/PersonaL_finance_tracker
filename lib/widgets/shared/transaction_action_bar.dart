import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';

class TransactionActionBar extends StatelessWidget {
  final int selectedCount;
  final bool isHistoryMode;
  final VoidCallback
  onPrimaryAction; // Restore for history, Archive for activity
  final VoidCallback onExport;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const TransactionActionBar({
    super.key,
    required this.selectedCount,
    required this.isHistoryMode,
    required this.onPrimaryAction,
    required this.onExport,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isHistoryMode ? "Action History" : "Batch Actions",
        ).titleLarge(color: Colors.white, weight: FontWeight.bold),
        8.heightBox,
        Text(
          "$selectedCount items selected",
        ).bodyLarge(color: Colors.white.withValues(alpha: 0.6)),
        24.heightBox,
        _buildMenuOption(
          icon: isHistoryMode
              ? Icons.settings_backup_restore_rounded
              : Icons.delete_sweep_rounded,
          title: isHistoryMode ? "Restore Selected" : "Delete Selected",
          iconColor: AppColors.primaryColor,
          onTap: onPrimaryAction,
        ),
        _buildMenuOption(
          icon: Icons.ios_share_rounded,
          title: "Export Selected",
          iconColor: Colors.cyanAccent,
          onTap: onExport,
        ),
        _buildMenuOption(
          icon: Icons.delete_outline_rounded,
          title: "Delete Permanently",
          iconColor: Colors.redAccent,
          onTap: onDelete,
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: GlassContainer(
          borderRadius: 18,
          blur: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          gradientColors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              16.widthBox,
              Expanded(
                child: Text(
                  title,
                ).titleMedium(color: Colors.white, weight: FontWeight.w600),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
