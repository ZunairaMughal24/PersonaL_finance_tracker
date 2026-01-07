import 'package:flutter/material.dart';

class AppColors {
  // Modern Dark Theme Base Colors
  static const Color background = Color(0xFF0A0E27);
  static const Color surface = Color(0xFF1A1F3A);
  static const Color surfaceLight = Color(0xFF252B48);

  // Primary Brand Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7FF4);
  static const Color primaryDark = Color(0xFF5443C7);

  // Accent Colors
  static const Color accent = Color(0xFF00D9FF);
  static const Color accentPink = Color(0xFFFF6B9D);

  // Semantic Colors
  static const Color green = Color(0xFF00E676);
  static const Color red = Color(0xFFFF5252);
  static const Color orange = Color(0xFFFFAB40);
  static const Color blue = Color(0xFF448AFF);

  // Text Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8D4);
  static const Color grey = Color(0xFF6B7280);
  static const Color transparent = Colors.transparent;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF6C5CE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFFF6B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 216, 141, 243),
      Color.fromARGB(255, 54, 47, 113),
      Color.fromARGB(255, 54, 47, 113),
    ], // Darker shades of the previous gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient homeGradient = LinearGradient(
    colors: [surface, surfaceLight], // Darker shades of the previous gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient transactionCardGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 19, 13, 60),
      Color.fromARGB(255, 63, 54, 146),
      Color.fromARGB(255, 96, 85, 194),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
