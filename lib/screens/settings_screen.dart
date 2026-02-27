import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/constants/appImages.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:personal_finance_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<UserSettingsProvider>();
    _nameController = TextEditingController(text: settings.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showEditProfileMenu(
    BuildContext context,
    UserSettingsProvider settings,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 24,
        blur: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.heightBox,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            20.heightBox,
            Text(
              "Edit Profile",
            ).h4(color: Colors.white, weight: FontWeight.bold),
            20.heightBox,
            _buildMenuOption(
              svgAsset: AppImages.user,
              title: "Edit Name",
              onTap: () {
                Navigator.pop(context);
                setState(() => _isEditingName = true);
              },
            ),
            Divider(color: Colors.white.withOpacity(0.05), height: 1),
            _buildMenuOption(
              icon: Icons.photo_library_outlined,
              title: "Change Photo",
              onTap: () {
                Navigator.pop(context);
                settings.pickAndUpdateProfileImage();
              },
            ),
            Divider(color: Colors.white.withOpacity(0.05), height: 1),
            _buildMenuOption(
              icon: Icons.delete_outline_rounded,
              title: "Remove Photo",
              iconColor: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                settings.removeProfileImage();
              },
            ),
            30.heightBox,
          ],
        ),
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
              Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Text(title).bodyLarge(color: Colors.white, weight: FontWeight.w500),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: CustomAppBar(
        title: "Settings",
        onLeadingTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.heightBox,
              _buildProfileCard(),
              18.heightBox,
              _buildSectionHeader("Account"),
              16.heightBox,
              _buildSettingsGroup([
                _buildSettingsTile(
                  svgAsset: AppImages.user,
                  iconColor: Colors.blueAccent,
                  title: "Personal Information",
                  subtitle: "Name, email",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  svgAsset: AppImages.lock,
                  iconColor: Colors.redAccent,
                  title: "Password",
                  subtitle: "Change password",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: Colors.greenAccent,
                  title: "Financial Wallets",
                  subtitle: "Manage your accounts and cards",
                  onTap: () {},
                ),
              ]),
              18.heightBox,
              _buildSectionHeader("Preferences"),
              16.heightBox,
              _buildSettingsGroup([
                Consumer<UserSettingsProvider>(
                  builder: (context, settings, _) => _buildSettingsTile(
                    svgAsset: AppImages.bell,
                    iconColor: Colors.orangeAccent,
                    title: "Notifications",
                    subtitle: "Manage notification settings",
                    trailing: Switch.adaptive(
                      value: settings.notificationsEnabled,
                      onChanged: (val) => settings.setNotificationsEnabled(val),
                      activeColor: AppColors.primaryColor,
                      activeTrackColor: AppColors.primaryColor.withOpacity(0.3),
                    ),
                    onTap: () {},
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: Colors.tealAccent,
                  title: "Language",
                  subtitle: "Change app language",
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "English",
                      ).bodySmall(color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.3),
                        size: 25,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                Consumer<UserSettingsProvider>(
                  builder: (context, settings, _) => _buildSettingsTile(
                    icon: Icons.monetization_on_outlined,
                    iconColor: Colors.amberAccent,
                    title: "Currency",
                    subtitle: "Default currency: ${settings.selectedCurrency}",
                    onTap: () => _showCurrencyPicker(context, settings),
                  ),
                ),
              ]),
              18.heightBox,
              _buildSectionHeader("Support"),
              16.heightBox,
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.help_outline_rounded,
                  iconColor: Colors.indigoAccent,
                  title: "Help Center",
                  subtitle: "FAQs and help center",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: Colors.cyanAccent,
                  title: "About",
                  subtitle: "Version 1.0.0",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent.withOpacity(0.8),
                  title: "Sign Out",
                  subtitle: "Exit from your account",
                  onTap: () {
                    context.read<AuthProvider>().signOut().then((_) {
                      context.go(AppRoutes.signInScreenRoute);
                    });
                  },
                  showChevron: false,
                ),
              ]),
              100.heightBox,
            ],
          ).px16(),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Consumer<UserSettingsProvider>(
      builder: (context, settings, _) => GlassContainer(
        borderRadius: 24,
        blur: 35,
        borderOpacity: 0.12,
        gradientColors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.02),
        ],
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                    backgroundImage: settings.profileImagePath != null
                        ? FileImage(File(settings.profileImagePath!))
                              as ImageProvider
                        : null,
                    child: settings.profileImagePath == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 32,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isEditingName
                      ? TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.greenAccent,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    settings.updateUserName(
                                      _nameController.text,
                                    );
                                    setState(() => _isEditingName = false);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _nameController.text = settings.userName;
                                    setState(() => _isEditingName = false);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onSubmitted: (val) {
                            settings.updateUserName(val);
                            setState(() => _isEditingName = false);
                          },
                        )
                      : Text(
                          settings.userName,
                        ).h4(color: Colors.white, weight: FontWeight.bold),
                  const SizedBox(height: 2),
                  Text(settings.userEmail).bodyMedium(
                    color: Colors.white.withOpacity(0.7),
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            if (!_isEditingName)
              IconButton(
                onPressed: () => _showEditProfileMenu(context, settings),
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                padding: const EdgeInsets.all(8),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  shape: const CircleBorder(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
    ).h3(color: Colors.white.withOpacity(0.7), weight: FontWeight.bold);
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return GlassContainer(
      borderRadius: 20,
      blur: 30,
      borderOpacity: 0.1,
      gradientColors: [
        Colors.white.withOpacity(0.05),
        Colors.white.withOpacity(0.02),
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
                  color: Colors.white.withOpacity(0.1),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingsTile({
    IconData? icon,
    String? svgAsset,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool showChevron = true,
  }) {
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
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset,
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
                  Text(subtitle).bodySmall(
                    color: Colors.white.withOpacity(0.7),
                    weight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 25,
              ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    UserSettingsProvider settings,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 24,
        blur: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.heightBox,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.white.withOpacity(0.05), height: 1),
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
}
