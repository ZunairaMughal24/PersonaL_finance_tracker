import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/animation_utils.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.showDropdown = false,
    this.suffixChild,
    this.prefixChild,
    required this.title,
    this.label,
    this.validator,
    this.errorText,
    this.onChanged,
    this.textInputAction,
  });

  final String title;
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool showDropdown;
  final Widget? suffixChild;
  final Widget? prefixChild;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (FormFieldState<String> field) {
        final String? displayError = widget.errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            ShakeTransition(
              shake: displayError != null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: displayError != null
                        ? Colors.redAccent.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.showDropdown,
                  onChanged: (value) {
                    field.didChange(value);
                    if (widget.onChanged != null) widget.onChanged!(value);
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    labelText: widget.label,
                    hintStyle: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    prefixIcon: widget.prefixChild,
                    suffixIcon: displayError != null
                        ? const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          )
                        : (widget.suffixChild ??
                              (widget.showDropdown
                                  ? const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    )
                                  : null)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  textInputAction: widget.textInputAction,
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: displayError == null
                  ? const SizedBox(width: double.infinity)
                  : FadeSlideTransition(
                      duration: const Duration(milliseconds: 200),
                      offset: const Offset(0, -5),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 4),
                        child: Text(
                          displayError,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
