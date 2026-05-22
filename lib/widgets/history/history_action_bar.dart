import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/widgets/glass_container.dart';

class HistoryActionBar extends StatelessWidget {
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const HistoryActionBar({
    super.key,
    required this.onRestore,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GlassContainer(
        borderRadius: 24,
        blur: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        gradientColors: [
          AppColors.primaryColor.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.05),
        ],
        child: Row(
          children: [
            _buildActionButton(
              icon: Icons.settings_backup_restore_rounded,
              label: "Restore",
              color: Colors.white,
              onTap: onRestore,
            ),
            _buildDivider(),
            _buildActionButton(
              icon: Icons.delete_sweep_rounded,
              label: "Delete",
              color: Colors.redAccent.shade100,
              onTap: onDelete,
            ),
            _buildDivider(),
            _buildActionButton(
              icon: Icons.close_rounded,
              label: "Cancel",
              color: Colors.white70,
              onTap: onCancel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
