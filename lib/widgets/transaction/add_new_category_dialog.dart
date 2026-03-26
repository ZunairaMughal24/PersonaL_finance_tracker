import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:provider/provider.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:montage/widgets/pulse_effect.dart';

class AddNewCategoryDialog extends StatefulWidget {
  final Function(String, IconData) onSubmitted;
  final bool isIncome;

  const AddNewCategoryDialog({
    super.key,
    required this.onSubmitted,
    required this.isIncome,
  });

  @override
  State<AddNewCategoryDialog> createState() => _AddNewCategoryDialogState();
}

class _AddNewCategoryDialogState extends State<AddNewCategoryDialog> {
  late final TextEditingController _controller;
  String? _errorText;
  IconData _selectedIcon = CategoryProvider.selectableIcons[0];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    final provider = context.read<CategoryProvider>();
    final error = provider.validateCategory(value, widget.isIncome);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    widget.onSubmitted(value, _selectedIcon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add Category").h2(color: Colors.white),
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
                "Set a name and icon for your new category",
              ).bodyLarge(color: Colors.white.withValues(alpha: 0.8)),
              20.heightBox,
              
              // ── NAME INPUT ──
              Consumer<SpeechViewModel>(
                builder: (context, speechVm, _) {
                  return TextField(
                    controller: _controller,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (_) {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: _errorText,
                      errorStyle: const TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
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
                            _controller.text = result;
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
                                      color:
                                          AppColors.green.withValues(alpha: 0.2),
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
                    onSubmitted: (_) => _submit(),
                  );
                },
              ),
              20.heightBox,

              // ── ICON PICKER ──
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: CategoryProvider.selectableIcons.length,
                itemBuilder: (context, index) {
                  final icon = CategoryProvider.selectableIcons[index];
                  final isSelected = _selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              
              30.heightBox,

              // ── CONFIRM BUTTON ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Confirm",
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
