import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:provider/provider.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:montage/widgets/pulse_effect.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/core/utils/category_utils.dart';
import 'package:montage/viewmodels/category_editor_view_model.dart';

class CategoryEditorDialog extends StatelessWidget {
  final Function(String, IconData, {Color? color}) onSubmitted;
  final bool isIncome;
  final CustomCategory? initialCategory;

  const CategoryEditorDialog({
    super.key,
    required this.onSubmitted,
    required this.isIncome,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryEditorViewModel(
        isIncome: isIncome,
        initialCategory: initialCategory,
      ),
      child: _CategoryEditorDialogView(
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _CategoryEditorDialogView extends StatelessWidget {
  final Function(String, IconData, {Color? color}) onSubmitted;

  const _CategoryEditorDialogView({required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryEditorViewModel>();
    final provider = context.read<CategoryProvider>();

    void submit() {
      if (vm.submit(provider)) {
        onSubmitted(
          vm.controller.text.trim(),
          vm.selectedIcon,
          color: vm.selectedColor,
        );
        Navigator.pop(context);
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 17),
      child: GlassContainer(
        borderRadius: 24,
        blur: 40,
        borderOpacity: 0.15,
        padding: const EdgeInsets.all(24),
        gradientColors: [
          Colors.white.withValues(alpha: 0.15),
          AppColors.primaryColor.withValues(alpha: 0.08),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vm.isEditMode ? "Edit Category" : "Add Category",
                  ).h2(color: Colors.white),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Text(
                vm.isEditMode
                    ? "Update your category details"
                    : "Set a name, icon & color for your new category",
              ).bodyLarge(
                color: Colors.white.withValues(alpha: 0.8),
                weight: FontWeight.w600,
              ),
              20.heightBox,

              Consumer<SpeechViewModel>(
                builder: (context, speechVm, _) {
                  return TextField(
                    controller: vm.controller,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: vm.errorText,
                      errorStyle: const TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => speechVm.toggleListening((result) {
                            vm.updateNameFromSpeech(result);
                          }),
                          onLongPress: () => speechVm.toggleLocale(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (speechVm.isListening)
                                PulseEffect(
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.green.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: speechVm.isListening
                                      ? AppColors.green.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  speechVm.isListening
                                      ? Icons.mic
                                      : Icons.mic_none_rounded,
                                  color: speechVm.isListening
                                      ? AppColors.green
                                      : Colors.white.withValues(alpha: 0.4),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (_) => submit(),
                  );
                },
              ),
              20.heightBox,

              // ICON PICKER
              Text("SELECT ICON").labelLarge(
                color: Colors.white.withValues(alpha: 0.5),
                weight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
              10.heightBox,

              SizedBox(
                height: 140,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: CategoryUtils.selectableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = CategoryUtils.selectableIcons[index];
                    final isSelected =
                        vm.selectedIcon.codePoint == icon.codePoint;
                    return GestureDetector(
                      onTap: () => vm.setIcon(icon),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? vm.selectedColor.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? vm.selectedColor
                                : Colors.white.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),

              16.heightBox,

              // COLOR PICKER
              Text("SELECT COLOR").labelLarge(
                color: Colors.white.withValues(alpha: 0.5),
                weight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
              10.heightBox,

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: CategoryUtils.selectableColors.map((color) {
                    final isSelected =
                        vm.selectedColor.toARGB32() == color.toARGB32();
                    return GestureDetector(
                      onTap: () => vm.setColor(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

              24.heightBox,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    vm.isEditMode ? "Update" : "Confirm",
                  ).titleLarge(weight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
