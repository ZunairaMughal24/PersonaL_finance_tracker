import 'package:flutter/material.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/padding_extention.dart';
import 'package:montage/widgets/settings_sections.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: const CustomAppBar(
        title: "Settings",
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.heightBox,
              const ProfileCard(),
              18.heightBox,
              const AccountSection(),
              18.heightBox,
              const PreferencesSection(),
              18.heightBox,
              const ExportSection(),
              18.heightBox,
              const SecuritySection(),
              18.heightBox,
              const SupportSection(),
              100.heightBox,
            ],
          ).px16(),
        ),
      ),
    );
  }
}

