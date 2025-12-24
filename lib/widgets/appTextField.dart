import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/const/appColors.dart';
import 'package:personal_finance_tracker/core/const/utils/widget_utility_extention.dart';

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
    this.label,  this.validator,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        8.heightBox,
        TextFormField(
       validator: validator,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: showDropdown,
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            labelText: label,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            prefixIcon: prefixChild,

            /// *** this shows dropdown or custom child ***
            suffixIcon:
                suffixChild ??
                (showDropdown
                    ? const Icon(Icons.arrow_drop_down, color: Colors.white)
                    : null),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
