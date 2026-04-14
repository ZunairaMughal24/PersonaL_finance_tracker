import 'package:flutter/material.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/core/utils/category_utils.dart';

class CategoryEditorViewModel extends ChangeNotifier {
  late final TextEditingController controller;
  IconData selectedIcon;
  Color selectedColor;
  String? errorText;

  final bool isIncome;
  final CustomCategory? initialCategory;

  bool get isEditMode => initialCategory != null;

  CategoryEditorViewModel({
    required this.isIncome,
    this.initialCategory,
  })  : selectedIcon = initialCategory != null
            ? IconData(
                initialCategory.iconCodePoint,
                fontFamily: 'MaterialIcons',
              )
            : CategoryUtils.selectableIcons[0],
        selectedColor =
            initialCategory?.color ?? CategoryUtils.selectableColors[0] {
    controller = TextEditingController(text: initialCategory?.name);
    controller.addListener(() {
      if (errorText != null) {
        errorText = null;
        notifyListeners();
      }
    });
  }

  void updateNameFromSpeech(String result) {
    controller.text = result;
  }

  void setIcon(IconData icon) {
    selectedIcon = icon;
    notifyListeners();
  }

  void setColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  bool submit(CategoryProvider provider) {
    final value = controller.text.trim();
    if (value.isEmpty) return false;

    final error = provider.validateCategory(
      value,
      isIncome,
      excludeName: initialCategory?.name,
    );

    if (error != null) {
      errorText = error;
      notifyListeners();
      return false; // Submission failed
    }

    return true; // Submission succeeded
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
