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
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
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
              hintStyle: TextStyle(color: AppColors.white.withOpacity(0.4)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              prefixIcon: prefixChild,
              suffixIcon:
                  suffixChild ??
                  (showDropdown
                      ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                      : null),

              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,

              errorStyle: const TextStyle(
                height: 0,
                fontSize: 0,
                color: Colors.transparent,
              ),
              errorMaxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
