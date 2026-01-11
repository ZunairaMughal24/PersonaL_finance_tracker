import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

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
              32.heightBox,
              _buildSectionHeader("Account"),
              16.heightBox,
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.person_outline_rounded,
                  iconColor: Colors.blueAccent,
                  title: "Personal Information",
                  subtitle: "Name, email",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline_rounded,
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
              32.heightBox,
              _buildSectionHeader("Preferences"),
              16.heightBox,
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.notifications_none_rounded,
                  iconColor: Colors.orangeAccent,
                  title: "Notifications",
                  subtitle: "Manage notification settings",
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                    activeColor: AppColors.primaryColor,
                    activeTrackColor: AppColors.primaryColor.withOpacity(0.3),
                  ),
                  onTap: () {},
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
                _buildSettingsTile(
                  icon: Icons.monetization_on_outlined,
                  iconColor: Colors.amberAccent,
                  title: "Currency",
                  subtitle: "Default currency: USD",
                  onTap: () {},
                ),
              ]),
              32.heightBox,
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
                  onTap: () {},
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
    return GlassContainer(
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
              backgroundColor: AppColors.primaryColor.withOpacity(0.5),
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1000&auto=format&fit=crop',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zunaira Mughal',
                ).h4(color: Colors.white, weight: FontWeight.bold),
                const SizedBox(height: 2),
                Text('zunaira@example.com').bodyMedium(
                  color: Colors.white.withOpacity(0.7),
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
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
    required IconData icon,
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
              child: Icon(icon, color: iconColor, size: 22),
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
}
