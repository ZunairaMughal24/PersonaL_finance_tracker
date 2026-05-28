import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/viewmodels/transaction_form_view_model.dart';
import 'package:montage/widgets/image_source_sheet.dart';
import 'package:montage/widgets/transaction/category_action_sheet.dart';
import 'package:montage/widgets/transaction/category_editor_dialog.dart';

class TransactionUIUtils {
  static Future<void> pickImage(
    BuildContext context,
    TransactionFormViewModel vm,
  ) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ImageSourceSheet(),
    );

    if (source != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        await vm.handleImageSelected(image.path, image.name);
      }
    }
  }

  static void handleCategoryActionUI({
    required BuildContext context,
    required TransactionFormViewModel vm,
    required CategoryProvider catProvider,
    required String catName,
  }) {
    final customCat = catProvider.getCategoryByName(catName, vm.isIncome);
    if (customCat == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryActionSheet(
        categoryName: catName,
        onEdit: () => _showEditCategoryDialog(
          context,
          vm,
          catProvider,
          catName,
          customCat,
        ),
        onDelete: () {
          catProvider.deleteCustomCategory(catName, vm.isIncome);
          if (vm.selectedCategory == catName) {
            vm.setCategory("Other");
          }
        },
      ),
    );
  }

  static void _showEditCategoryDialog(
    BuildContext context,
    TransactionFormViewModel vm,
    CategoryProvider catProvider,
    String catName,
    dynamic customCat,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => CategoryEditorDialog(
        isIncome: vm.isIncome,
        initialCategory: customCat,
        onSubmitted: (newName, newIcon, {Color? color}) {
          catProvider.updateCustomCategory(
            catName,
            newName,
            newIcon,
            vm.isIncome,
            color: color,
          );
          if (vm.selectedCategory == catName) {
            vm.setCategory(newName);
          }
        },
      ),
    );
  }
}
