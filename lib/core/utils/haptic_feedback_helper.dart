import 'package:flutter/services.dart';

class HapticHelper {
  /// A light vibration for standard button presses
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// A medium vibration for more significant actions (like switching tabs)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// A heavy vibration for critical actions or errors
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// A specific pattern for successful operations
  static Future<void> success() async {
    await HapticFeedback.vibrate();
  }

  /// Selection feedback (tick-like)
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }
}
