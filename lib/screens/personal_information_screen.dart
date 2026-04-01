import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/padding_extention.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:provider/provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late TextEditingController _nameController;
  bool _isEditingName = false;

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
    return AppBackground(
      style: BackgroundStyle.silkDark,
      appBar: const CustomAppBar(
        title: "Personal Information",
      ),
      child: SafeArea(
        child: Consumer<UserSettingsProvider>(
          builder: (context, settings, _) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.heightBox,
                GlassContainer(
                  borderRadius: 20,
                  blur: 30,
                  borderOpacity: 0.1,
                  gradientColors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildField(
                        label: "Full Name",
                        value: settings.userName,
                        isEditing: _isEditingName,
                        controller: _nameController,
                        onEditTap: () {
                          setState(() {
                            _isEditingName = true;
                            _nameController.text = settings.userName;
                          });
                        },
                        onSave: () {
                          settings.updateUserName(_nameController.text);
                          setState(() => _isEditingName = false);
                        },
                        onCancel: () {
                          _nameController.text = settings.userName;
                          setState(() => _isEditingName = false);
                        },
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      _buildReadOnlyField(
                        label: "Email Address",
                        value: settings.userEmail,
                        hint: "Linked to your account",
                      ),
                    ],
                  ),
                ),
              ],
            ).px16(),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onEditTap,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label).bodySmall(
            color: Colors.white.withValues(alpha: 0.5),
            weight: FontWeight.w600,
          ),
          8.heightBox,
          isEditing
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: keyboardType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => onSave(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.greenAccent,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ).bodyLarge(
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditTap,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 18,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label).bodySmall(
            color: Colors.white.withValues(alpha: 0.5),
            weight: FontWeight.w600,
          ),
          8.heightBox,
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ).bodyLarge(
            color: Colors.white.withValues(alpha: 0.7),
            weight: FontWeight.w500,
          ),
          if (hint != null) ...[
            6.heightBox,
            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(hint).bodySmall(
                  color: Colors.white.withValues(alpha: 0.3),
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
