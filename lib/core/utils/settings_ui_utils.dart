import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montage/providers/user_settings_provider.dart';

class SettingsUIUtils {
  static Future<void> pickProfileImage(
    BuildContext context,
    UserSettingsProvider settings,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await settings.updateProfileImage(image.path);
    }
  }
}
