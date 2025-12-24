import 'package:flutter/material.dart';

import 'package:personal_finance_tracker/core/contants/appColors.dart';

class AppTheme {
  static Color get primaryLight => AppColors.primaryColor;

  static ThemeData get lightTheme {
    return ThemeData(
      canvasColor: Colors.white,
      primaryColor: primaryLight,
      dividerColor: Colors.grey,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.light,
        primary: primaryLight,
        secondary: primaryLight,
        surface: const Color(0XFFF5F5F5),
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
    );
  }
}
