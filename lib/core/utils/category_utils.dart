import 'package:flutter/material.dart';

class CategoryUtils {
  static final List<Map<String, dynamic>> expenseCategories = [
    {
      'name': 'Food',
      'icon': Icons.restaurant_rounded,
      'color': Color.fromARGB(255, 248, 211, 162),
    },
    {
      'name': 'Transport',
      'icon': Icons.directions_car_rounded,
      'color': Color.fromARGB(255, 172, 197, 241),
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_rounded,
      'color': Color(0xFF6C5CE7),
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_long_rounded,
      'color': Color.fromARGB(255, 174, 231, 230),
    },
    {'name': 'Home', 'icon': Icons.home_rounded, 'color': Color(0xFFFDCB6E)},
    {
      'name': 'Entertainment',
      'icon': Icons.movie_rounded,
      'color': Color.fromARGB(255, 201, 209, 131),
    },
    {
      'name': 'Health',
      'icon': Icons.medical_services_rounded,
      'color': Color.fromARGB(255, 135, 244, 151),
    },
    {
      'name': 'Education',
      'icon': Icons.school_rounded,
      'color': Color.fromARGB(255, 152, 172, 237),
    },
    {
      'name': 'Fitness',
      'icon': Icons.fitness_center_rounded,
      'color': Color.fromARGB(255, 114, 238, 178),
    },
    {
      'name': 'Subscription',
      'icon': Icons.subscriptions_rounded,
      'color': Color.fromARGB(255, 255, 129, 139),
    },
    {
      'name': 'Insurance',
      'icon': Icons.security_rounded,
      'color': Color.fromARGB(255, 189, 213, 254),
    },
    {
      'name': 'Travel',
      'icon': Icons.flight_rounded,
      'color': Color.fromARGB(255, 158, 235, 252),
    },
    {
      'name': 'Maintenance',
      'icon': Icons.build_rounded,
      'color': Color.fromARGB(255, 184, 253, 213),
    },
    {
      'name': 'Beauty',
      'icon': Icons.face_retouching_natural_rounded,
      'color': Color.fromARGB(255, 249, 189, 209),
    },
    {
      'name': 'Gift',
      'icon': Icons.card_giftcard_rounded,
      'color': Color(0xFFFDCB6E),
    },
    {
      'name': 'Streaming',
      'icon': Icons.play_circle_filled_rounded,
      'color': Color.fromARGB(255, 189, 130, 158),
    },
    {
      'name': 'Coffee',
      'icon': Icons.coffee_rounded,
      'color': Color.fromARGB(255, 182, 174, 244),
    },
    {
      'name': 'Groceries',
      'icon': Icons.local_grocery_store_rounded,
      'color': Color.fromARGB(220, 171, 235, 204),
    },
    {
      'name': 'Laundry',
      'icon': Icons.local_laundry_service_rounded,
      'color': Color.fromARGB(255, 48, 162, 160),
    },
    {'name': 'Pets', 'icon': Icons.pets_rounded, 'color': Color(0xFFFDCB6E)},
    {
      'name': 'Hobbies',
      'icon': Icons.interests_rounded,
      'color': Color.fromARGB(255, 122, 107, 238),
    },
    {
      'name': 'Charity',
      'icon': Icons.favorite_rounded,
      'color': Color.fromARGB(255, 202, 156, 237),
    },
    {
      'name': 'Parking',
      'icon': Icons.local_parking_rounded,
      'color': Color.fromARGB(255, 170, 141, 207),
    },
    {
      'name': 'Fuel',
      'icon': Icons.local_gas_station_rounded,
      'color': Color.fromARGB(255, 216, 182, 138),
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices_rounded,
      'color': Color.fromARGB(255, 125, 174, 182),
    },
    {
      'name': 'Kids',
      'icon': Icons.child_care_rounded,
      'color': Color.fromARGB(255, 224, 255, 133),
    },
    {
      'name': 'Clothes',
      'icon': Icons.checkroom_rounded,
      'color': Color(0xFF6C5CE7),
    },
    {'name': 'Rent', 'icon': Icons.room_rounded, 'color': Color(0xFF448AFF)},
    {
      'name': 'Other',
      'icon': Icons.more_horiz_rounded,
      'color': Color(0xFFB0B8D4),
    },
  ];

  static final List<Map<String, dynamic>> incomeCategories = [
    {
      'name': 'Salary',
      'icon': Icons.attach_money_rounded,
      'color': Color(0xFF00E676),
    },
    {
      'name': 'Investment',
      'icon': Icons.trending_up_rounded,
      'color': Color(0xFF00D9FF),
    },
    {
      'name': 'Business',
      'icon': Icons.store_rounded,
      'color': Color(0xFFFDCB6E),
    },
    {
      'name': 'Freelance',
      'icon': Icons.work_rounded,
      'color': Color(0xFF00CEC9),
    },
    {
      'name': 'Rental',
      'icon': Icons.apartment_rounded,
      'color': Color(0xFFFDCB6E),
    },
    {
      'name': 'Dividend',
      'icon': Icons.pie_chart_rounded,
      'color': Color(0xFF6C5CE7),
    },
    {
      'name': 'Interest',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF00D9FF),
    },
    {'name': 'Selling', 'icon': Icons.sell_rounded, 'color': Color(0xFFFFAB40)},
    {
      'name': 'Gift',
      'icon': Icons.card_giftcard_rounded,
      'color': Color(0xFFBA68C8),
    },
    {'name': 'Bonus', 'icon': Icons.star_rounded, 'color': Color(0xFFFDCB6E)},
    {
      'name': 'Refund',
      'icon': Icons.replay_rounded,
      'color': Color(0xFF55E6C1),
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz_rounded,
      'color': Color(0xFFB0B8D4),
    },
  ];

  static List<String> get spendingCategories {
    final Set<String> categories = {};
    for (var cat in expenseCategories) {
      categories.add(cat['name'] as String);
    }
    for (var cat in incomeCategories) {
      categories.add(cat['name'] as String);
    }
    return categories.toList();
  }

  static IconData getIconForCategory(String category) {
    final allCategories = [...expenseCategories, ...incomeCategories];
    final match = allCategories.firstWhere(
      (c) => c['name'].toString().toLowerCase() == category.toLowerCase(),
      orElse: () => {'icon': Icons.monetization_on_outlined},
    );
    return match['icon'] as IconData;
  }

  static Color getCategoryColor(String category) {
    final allCategories = [...expenseCategories, ...incomeCategories];
    final match = allCategories.firstWhere(
      (c) => c['name'].toString().toLowerCase() == category.toLowerCase(),
      orElse: () => {'color': const Color(0xFFB0B8D4)},
    );
    return match['color'] as Color;
  }
}
