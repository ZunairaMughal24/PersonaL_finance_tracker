import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

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
        if (isHistoryMode)
          _buildMenuOption(
            icon: Icons.settings_backup_restore_rounded,
            title: "Restore Selected",
            iconColor: Colors.blueAccent,
            onTap: onPrimaryAction,
          ),
        _buildMenuOption(
          icon: Icons.ios_share_rounded,
          title: "Export Selected",
          iconColor: Colors.cyanAccent,
          onTap: onExport,
        ),
        _buildMenuOption(
          svgAsset: AppImages.trashBin,
          title: isHistoryMode ? "Delete Permanently" : "Move to Trash",
          iconColor: Colors.redAccent,
          onTap: isHistoryMode ? onDelete : onPrimaryAction,
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    IconData? icon,
    String? svgAsset,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          borderRadius: 16,
          blur: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          gradientColors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: svgAsset != null
                    ? SvgPicture.asset(
                        svgAsset,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                        height: 20,
                      )
                    : Icon(icon, color: iconColor, size: 20),
              ),
              14.widthBox,
              Expanded(
                child: Text(
                  title,
                ).bodyLarge(color: Colors.white, weight: FontWeight.w600),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.2),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
