import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: CustomAppBar(
        title: "Profile",
        onLeadingTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              20.heightBox,
              _buildProfileHeader(),
              20.heightBox,
              _buildSettingsSection(context),
              20.heightBox,
              _buildAppInfo(),
              100.heightBox,
            ],
          ).px16(),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.5),
                    AppColors.primaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white12,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1000&auto=format&fit=crop',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        20.heightBox,
        const Text(
          'Zunaira Mughal',
        ).h2(color: Colors.white, weight: FontWeight.bold),
        6.heightBox,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Text('zunaira@example.com').bodyMedium(
            color: Colors.white.withOpacity(0.5),
            weight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _buildSettingsTile(
              icon: Icons.account_balance_wallet_outlined,
              title: "Financial Wallets",
              subtitle: "Manage your accounts and cards",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.notifications_none_rounded,
              title: "Notification Center",
              subtitle: "Alerts & updates configuration",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.security_outlined,
              title: "Security & Privacy",
              subtitle: "Passcode & biometrics",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: "Support",
              subtitle: "FAQs and help center",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.logout_rounded,
              title: "Sign Out",
              color: Colors.redAccent.withOpacity(0.8),
              onTap: () {},
              showArrow: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return GlassContainer(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              'Personal Finance Tracker',
            ).labelLarge(color: Colors.white.withOpacity(0.3)),
            4.heightBox,
            Text('Version 1.0.0').caption(color: Colors.white.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title).labelLarge(color: color, weight: FontWeight.w600),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle).caption(
                      color: Colors.white.withOpacity(0.3),
                      weight: FontWeight.w500,
                    ),
                  ],
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.2),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.5, color: Colors.white.withOpacity(0.05));
  }
}
