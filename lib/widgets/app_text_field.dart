import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';

class AppTextField extends StatelessWidget {
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
  final bool showDropdown;
  final Widget? suffixChild;
  final Widget? prefixChild;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: controller?.text,
      builder: (FormFieldState<String> field) {
        // Use either the manually passed errorText or the validator's errorText
        final String? displayError = errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: displayError != null
                      ? Colors.red.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                readOnly: showDropdown,
                onChanged: (value) {
                  field.didChange(value);
                  if (onChanged != null) onChanged!(value);
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  labelText: label,
                  hintStyle: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  prefixIcon: prefixChild,
                  suffixIcon:
                      suffixChild ??
                      (showDropdown
                          ? const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            )
                          : null),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 18, // Reserve enough height for the error text
              child: displayError != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        displayError,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
