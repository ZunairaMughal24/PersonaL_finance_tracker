import 'package:flutter/material.dart';

class CategoryUtils {
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'health':
        return Icons.medical_services_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'salary':
        return Icons.attach_money_rounded;
      case 'investment':
        return Icons.trending_up_rounded;
      case 'business':
        return Icons.store_rounded;
      case 'gift':
        return Icons.card_giftcard_rounded;
      case 'bonus':
        return Icons.star_rounded;
      default:
        return Icons.monetization_on_outlined;
    }
  }
}
