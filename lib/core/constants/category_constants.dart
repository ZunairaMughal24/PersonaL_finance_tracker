import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

class CategoryConstants {
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'color': AppColors.red},
    {
      'name': 'Transport',
      'icon': Icons.directions_car_rounded,
      'color': Colors.blue,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_rounded,
      'color': Colors.purple,
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_long_rounded,
      'color': Colors.orange,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.movie_rounded,
      'color': Colors.pink,
    },
    {
      'name': 'Health',
      'icon': Icons.medical_services_rounded,
      'color': Colors.redAccent,
    },
    {'name': 'Education', 'icon': Icons.school_rounded, 'color': Colors.indigo},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey},
  ];

  static const List<Map<String, dynamic>> incomeCategories = [
    {
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': AppColors.green,
    },
    {
      'name': 'Investment',
      'icon': Icons.trending_up_rounded,
      'color': Colors.blue,
    },
    {'name': 'Business', 'icon': Icons.store_rounded, 'color': Colors.orange},
    {
      'name': 'Gift',
      'icon': Icons.card_giftcard_rounded,
      'color': Colors.purple,
    },
    {'name': 'Bonus', 'icon': Icons.star_rounded, 'color': Colors.amber},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey},
  ];
}
