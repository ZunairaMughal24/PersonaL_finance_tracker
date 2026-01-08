import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildSettingsSection(context),
            const SizedBox(height: 20),
            _buildAppInfo(),
            const SizedBox(height: 100),
          ],
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
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 60, color: Colors.white24),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Zunaira Mughal',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'zunaira@example.com',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.4),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: "Manage Wallets",
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.security_rounded,
            title: "Security",
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.logout_rounded,
            title: "Log Out",
            color: Colors.redAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color.withOpacity(0.2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      indent: 10,
      endIndent: 10,
      color: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        const Text(
          'Personal Finance Tracker',
          style: TextStyle(color: Colors.white24, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.2)),
        ),
      ],
    );
  }
}
