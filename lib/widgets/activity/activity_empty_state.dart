import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class ActivityEmptyState extends StatelessWidget {
  const ActivityEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          16.heightBox,
          Text(
            "No transactions found",
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
