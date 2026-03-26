import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/glass_container.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
    ).h4(color: Colors.white.withValues(alpha: 0.7), weight: FontWeight.bold);
  }
}

class SettingsGroup extends StatelessWidget {
  final List<Widget> tiles;
  const SettingsGroup({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 20,
      blur: 30,
      borderOpacity: 0.1,
      gradientColors: [
        Colors.white.withValues(alpha: 0.05),
        Colors.white.withValues(alpha: 0.02),
      ],
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(tiles.length, (index) {
           return Column(
            children: [
              tiles[index],
              if (index != tiles.length - 1)
                Divider(
                  height: 1,
                  thickness: 1.4,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showChevron;

  const SettingsTile({
    super.key,
    this.icon,
    this.svgAsset,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset!,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      height: 22,
                    )
                  : Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                  ).bodyLarge(color: Colors.white, weight: FontWeight.w600),
                  const SizedBox(height: 2),
                  Text(subtitle).bodyMedium(
                    color: Colors.white.withValues(alpha: 0.7),
                    weight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.5),
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsModals {
  static void showCurrencyPicker(
    BuildContext context,
    UserSettingsProvider settings,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        customBorderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
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
            20.heightBox,
            Text(
              "Select Currency",
            ).h4(color: Colors.white, weight: FontWeight.bold),
            20.heightBox,
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: UserSettingsProvider.availableCurrencies.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withValues(alpha: 0.05),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final currency =
                      UserSettingsProvider.availableCurrencies[index];
                  final isSelected = settings.selectedCurrency == currency;

                  return InkWell(
                    onTap: () {
                      settings.setCurrency(currency);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currency).bodyLarge(
                            color: isSelected ? Colors.white : Colors.white60,
                            weight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            30.heightBox,
          ],
        ),
      ),
    );
  }

  static Widget buildMenuOption({
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
              Icon(icon, color: iconColor, size: 24),
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

  static void showEditProfileMenu({
    required BuildContext context,
    required UserSettingsProvider settings,
    required VoidCallback onEditNameTap,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        customBorderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
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
            20.heightBox,
            Text(
              "Edit Profile",
            ).h4(color: Colors.white, weight: FontWeight.bold),
            20.heightBox,
            buildMenuOption(
              icon: Icons.person,
              title: "Edit Name",
              onTap: () {
                Navigator.pop(context);
                onEditNameTap();
              },
            ),
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
            buildMenuOption(
              icon: Icons.photo_library_outlined,
              title: settings.profileImagePath != null ? "Change Photo" : "Add Photo",
              onTap: () {
                Navigator.pop(context);
                settings.pickAndUpdateProfileImage();
              },
            ),
            if (settings.profileImagePath != null) ...[
              Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
              buildMenuOption(
                svgAsset: AppImages.trashBin,
                title: "Remove Photo",
                iconColor: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  settings.removeProfileImage();
                },
              ),
            ],
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
