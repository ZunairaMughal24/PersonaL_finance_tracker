import 'package:flutter/material.dart';

class AppTextTheme {
  // Heading Styles
  static TextStyle h1({Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontSize: 32, height: 1.3, fontWeight: weight, color: color);

  static TextStyle h2({Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontSize: 28, height: 1.3, fontWeight: weight, color: color);

  static TextStyle h3({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(fontSize: 24, height: 1.3, fontWeight: weight, color: color);

  static TextStyle h4({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(fontSize: 20, height: 1.3, fontWeight: weight, color: color);

  // Body Text Styles
  static TextStyle bodyLarge({
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(fontSize: 18, height: 1.5, fontWeight: weight, color: color);

  static TextStyle bodyMedium( {
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(fontSize: 16, height: 1.5, fontWeight: weight, color: color);

  static TextStyle bodySmall({
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(fontSize: 14, height: 1.5, fontWeight: weight, color: color);

  // Label Styles
  static TextStyle labelLarge({
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(fontSize: 16, height: 1.2, fontWeight: weight, color: color);

  static TextStyle labelMedium({
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(fontSize: 14, height: 1.2, fontWeight: weight, color: color);

  static TextStyle labelSmall({
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(fontSize: 12, height: 1.2, fontWeight: weight, color: color);

  // Button Text Styles
  static TextStyle buttonLarge({
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(fontSize: 18, height: 1.2, fontWeight: weight, color: color);

  static TextStyle buttonMedium({
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(fontSize: 16, height: 1.2, fontWeight: weight, color: color);

  static TextStyle buttonSmall({
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(fontSize: 14, height: 1.2, fontWeight: weight, color: color);

  // Caption Styles
  static TextStyle caption({
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(fontSize: 12, height: 1.3, fontWeight: weight, color: color);

  // Link Styles
  static TextStyle link({Color? color, FontWeight weight = FontWeight.w500}) =>
      TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: weight,
        decoration: TextDecoration.underline,
        color: color,
      );

  // Custom Styles for specific use cases
  static TextStyle title({Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontSize: 22, height: 1.3, fontWeight: weight, color: color);

  static TextStyle subtitle({
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(fontSize: 18, height: 1.3, fontWeight: weight, color: color);
}
