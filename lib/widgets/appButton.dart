import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.height = 50,
    this.width,
    this.borderRadius = 12,
    this.icon,
    this.isLoading = false,
    this.borderColor,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double height;
  final double? width;
  final double borderRadius;
  final Widget? icon;
  final bool isLoading;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: color == Colors.transparent ? 0 : 3,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : icon == null
            ? Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  8.widthBox,
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
