import 'package:flutter/material.dart';

class CustomCategory {
  final String name;
  final int iconCodePoint;
  final bool isIncome;

  CustomCategory({
    required this.name,
    required this.iconCodePoint,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': iconCodePoint,
      'isIncome': isIncome,
    };
  }

  factory CustomCategory.fromMap(Map<dynamic, dynamic> map) {
    return CustomCategory(
      name: map['name'] as String,
      iconCodePoint: map['iconCodePoint'] as int,
      isIncome: (map['isIncome'] as bool?) ?? false,
    );
  }

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
