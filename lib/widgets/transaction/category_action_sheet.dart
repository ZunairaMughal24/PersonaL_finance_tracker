import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class CategoryActionSheet extends StatelessWidget {
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryActionSheet({
    super.key,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      customBorderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      blur: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          12.heightBox,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          8.heightBox,

          _buildMenuOption(
            icon: Icons.edit_rounded,
            title: "Edit Category",
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
          _buildMenuOption(
            svgAsset: AppImages.trashBin,
            title: "Delete Category",
            iconColor: Colors.redAccent,
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          30.heightBox,
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    IconData? icon,
    String? svgAsset,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                height: 24,
              )
            else
              Icon(icon, color: iconColor, size: 26),
            const SizedBox(width: 16),
            Text(title).bodyLarge(color: Colors.white, weight: FontWeight.w500),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
