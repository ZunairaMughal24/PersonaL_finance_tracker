import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

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
  });
  final String title;
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool showDropdown;
  final Widget? suffixChild;
  final Widget? prefixChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: AppColors.white.withOpacity(0.05),
                offset: const Offset(-1, -1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            readOnly: showDropdown,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              prefixIcon: prefixChild,
              suffixIcon:
                  suffixChild ??
                  (showDropdown
                      ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                      : null),

              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.red, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
