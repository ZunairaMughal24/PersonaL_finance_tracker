import 'package:flutter/material.dart';

class CustomCategory {
  final String name;
  final int iconCodePoint;
  final bool isIncome;
  final int? colorValue;

  CustomCategory({
    required this.name,
    required this.iconCodePoint,
    required this.isIncome,
    this.colorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': iconCodePoint,
      'isIncome': isIncome,
      'colorValue': colorValue,
    };
  }

  factory CustomCategory.fromMap(Map<dynamic, dynamic> map) {
    return CustomCategory(
      name: map['name'] as String,
      iconCodePoint: map['iconCodePoint'] as int,
      isIncome: (map['isIncome'] as bool?) ?? false,
      colorValue: map['colorValue'] as int?,
    );
  }

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Color get color => colorValue != null
      ? Color(colorValue!)
      : const Color(0xFFB0B8D4);
}
