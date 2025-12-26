import 'package:flutter/material.dart';

class CategoryConfig {
  final Color color;
  final IconData icon;

  CategoryConfig({required this.color, required this.icon});
}

final Map<String, CategoryConfig> categoryDetails = {
  'Food': CategoryConfig(color: Colors.green, icon: Icons.fastfood),
  'Rent': CategoryConfig(color: Colors.blue, icon: Icons.home),
  'Transport': CategoryConfig(color: Colors.orange, icon: Icons.directions_bus),
  'Entertainment': CategoryConfig(color: Colors.purple, icon: Icons.movie),
  'Shopping': CategoryConfig(color: Colors.pink, icon: Icons.shopping_cart),
};