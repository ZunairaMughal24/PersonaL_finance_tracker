import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:montage/config/router.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/services/export_service.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/settings_components.dart';

void _showWorkInProgress(BuildContext context) {
  ToastUtils.show(context, "Implementation is in progress", isError: false);
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettingsProvider>(
      builder: (context, settings, _) => GlassContainer(
        borderRadius: 24,
        blur: 35,
        borderOpacity: 0.12,
        gradientColors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.02),
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
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    backgroundImage: settings.profileImagePath != null
                        ? FileImage(File(settings.profileImagePath!))
                            as ImageProvider
                        : null,
                    child: settings.profileImagePath == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 28,
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
                  Text(
                    settings.userEmail,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ).bodyMedium(
                    color: Colors.white.withValues(alpha: 0.7),
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            if (!_isEditingName)
              IconButton(
                onPressed: () => SettingsModals.showEditProfileMenu(
                  context: context,
                  settings: settings,
                  onEditNameTap: () => setState(() => _isEditingName = true),
                ),
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
                padding: const EdgeInsets.all(8),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  shape: const CircleBorder(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Account"),
        16.heightBox,
        SettingsGroup(tiles: [
          SettingsTile(
            svgAsset: AppImages.user,
            iconColor: Colors.blueAccent,
            title: "Personal Information",
            subtitle: "Name, email",
            onTap: () => context.push(AppRoutes.personalInformationScreenRoute),
          ),
          SettingsTile(
            svgAsset: AppImages.lock,
            iconColor: Colors.redAccent,
            title: "Password",
            subtitle: "Change password",
            onTap: () => _showWorkInProgress(context),
          ),
          SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Colors.greenAccent,
            title: "Financial Wallets",
            subtitle: "Manage your accounts and cards",
            onTap: () => _showWorkInProgress(context),
          ),
        ]),
      ],
    );
  }
}

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Security"),
        16.heightBox,
        SettingsGroup(tiles: [
          Consumer<UserSettingsProvider>(
            builder: (context, settings, _) => SettingsTile(
              icon: Icons.fingerprint_rounded,
              iconColor: Colors.blueAccent,
              title: "Biometric Lock",
              subtitle: "Secure app with fingerprint/FaceID",
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: settings.biometricEnabled,
                  onChanged: (val) {
                    settings.setBiometricEnabled(val);
                    _showWorkInProgress(context);
                  },
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withValues(
                    alpha: 0.3,
                  ),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.transparent,
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return Colors.white.withValues(alpha: 0.3);
                    },
                  ),
                ),
              ),
              onTap: () => _showWorkInProgress(context),
            ),
          ),
          SettingsTile(
            svgAsset: AppImages.lock,
            iconColor: Colors.redAccent,
            title: "Privacy Policy",
            subtitle: "Read our privacy terms",
            onTap: () => _showWorkInProgress(context),
          ),
        ]),
      ],
    );
  }
}

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Preferences"),
        16.heightBox,
        SettingsGroup(tiles: [
          Consumer<UserSettingsProvider>(
            builder: (context, settings, _) => SettingsTile(
              svgAsset: AppImages.bell,
              iconColor: Colors.orangeAccent,
              title: "Notifications",
              subtitle: "Manage notification settings",
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: settings.notificationsEnabled,
                  onChanged: (val) {
                    settings.setNotificationsEnabled(val);
                    _showWorkInProgress(context);
                  },
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withValues(
                    alpha: 0.3,
                  ),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.transparent,
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return Colors.white.withValues(alpha: 0.3);
                    },
                  ),
                ),
              ),
              onTap: () => _showWorkInProgress(context),
            ),
          ),
          SettingsTile(
            icon: Icons.language_rounded,
            iconColor: Colors.tealAccent,
            title: "Language",
            subtitle: "Change app language",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "English",
                ).bodySmall(color: Colors.white.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 25,
                ),
              ],
            ),
            onTap: () => _showWorkInProgress(context),
          ),
          Consumer<UserSettingsProvider>(
            builder: (context, settings, _) => SettingsTile(
              icon: Icons.monetization_on_outlined,
              iconColor: Colors.amberAccent,
              title: "Currency",
              subtitle: "Default currency: ${settings.selectedCurrency}",
              onTap: () => SettingsModals.showCurrencyPicker(context, settings),
            ),
          ),
        ]),
      ],
    );
  }
}

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Data Management"),
        16.heightBox,
        SettingsGroup(tiles: [
          SettingsTile(
            icon: Icons.file_download_outlined,
            iconColor: Colors.greenAccent,
            title: "Export as CSV",
            subtitle: "Download all transactions in CSV format",
            onTap: () {
              final txProvider = context.read<TransactionProvider>();
              final settings = context.read<UserSettingsProvider>();
              ExportService.exportToCSV(txProvider.transactions, settings.userName);
            },
          ),
          SettingsTile(
            icon: Icons.picture_as_pdf_outlined,
            iconColor: Colors.redAccent,
            title: "Export as PDF",
            subtitle: "Generate a professional PDF report",
            onTap: () {
              final txProvider = context.read<TransactionProvider>();
              final settings = context.read<UserSettingsProvider>();
              ExportService.exportToPDF(
                txProvider.transactions,
                settings.selectedCurrency,
                settings.userName,
              );
            },
          ),
        ]),
      ],
    );
  }
}

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Support"),
        16.heightBox,
        SettingsGroup(tiles: [
          SettingsTile(
            icon: Icons.help_outline_rounded,
            iconColor: Colors.indigoAccent,
            title: "Help Center",
            subtitle: "FAQs and help center",
            onTap: () => _showWorkInProgress(context),
          ),
          SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: Colors.cyanAccent,
            title: "About",
            subtitle: "Version 1.4.0",
            onTap: () => _showWorkInProgress(context),
          ),
          SettingsTile(
            icon: Icons.logout_rounded,
            iconColor: Colors.redAccent.withValues(alpha: 0.8),
            title: "Sign Out",
            subtitle: "Exit from your account",
            onTap: () {
              context.read<AuthProvider>().signOut().then((_) {
                if (context.mounted) {
                  context.go(AppRoutes.signInScreenRoute);
                }
              });
            },
            showChevron: false,
          ),
        ]),
      ],
    );
  }
}
