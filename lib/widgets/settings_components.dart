import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';

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
  final String? imageAsset;
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
    this.imageAsset,
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
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset!,
                      color: iconColor,
                      height: 22,
                      width: 22,
                    )
                  : svgAsset != null
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
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
        ],
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
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Edit Profile",
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          20.heightBox,
          _buildMenuRow(
            icon: Icons.person,
            title: "Edit Name",
            onTap: () {
              Navigator.pop(context);
              onEditNameTap();
            },
          ),
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
          _buildMenuRow(
            icon: Icons.photo_library_outlined,
            title: settings.profileImagePath != null
                ? "Change Photo"
                : "Add Photo",
            onTap: () {
              Navigator.pop(context);
              settings.pickAndUpdateProfileImage();
            },
          ),
          if (settings.profileImagePath != null) ...[
            Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
            _buildMenuRow(
              svgAsset: AppImages.trashBin,
              title: "Remove Photo",
              iconColor: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                settings.removeProfileImage();
              },
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildMenuRow({
    IconData? icon,
    String? svgAsset,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        child: Row(
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                height: 22,
              )
            else
              Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Text(title).bodyLarge(color: Colors.white, weight: FontWeight.w500),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  static void showLogoutConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Sign Out").titleLarge(color: Colors.white),
          12.heightBox,
          Text(
            "Are you sure you want to sign out? You'll need to enter your credentials to log back in to your account.",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          AppButton(
            text: "Sign Out",
            color: Colors.redAccent.withValues(alpha: 0.9),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
          12.heightBox,
          AppButton(
            text: "Cancel",
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static void showClearDashboardConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Clear Dashboard").titleLarge(color: Colors.white),
          12.heightBox,
          Text(
            "This will archive all your current transactions and move them to history. You can restore them later.",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          AppButton(
            text: "Move to History",
            color: Colors.orangeAccent.withValues(alpha: 0.9),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
          12.heightBox,
          AppButton(
            text: "Cancel",
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static void showCsvExportOptions({
    required BuildContext context,
    required Function(bool) onConfirm,
  }) {
    _showExportOptions(context, "Export as CSV", onConfirm);
  }

  static void showPdfExportOptions({
    required BuildContext context,
    required Function(bool) onConfirm,
  }) {
    _showExportOptions(context, "Export as PDF", onConfirm);
  }

  static void _showExportOptions(
    BuildContext context,
    String title,
    Function(bool) onConfirm,
  ) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title).titleLarge(color: Colors.white),
          12.heightBox,
          Text(
            "Would you like to include your deleted transaction history in this report?",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          AppButton(
            text: "Include History",
            color: AppColors.primaryColor.withValues(alpha: 0.9),
            onPressed: () {
              Navigator.pop(context);
              onConfirm(true);
            },
          ),
          12.heightBox,
          AppButton(
            text: "Current Dashboard Only",
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
              onConfirm(false);
            },
          ),
        ],
      ),
    );
  }
}
