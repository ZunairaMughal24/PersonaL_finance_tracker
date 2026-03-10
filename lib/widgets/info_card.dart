import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/app_colors.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/text_theme_extension.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String amount;
  final Color amountColor;

  const InfoBox({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = title.toLowerCase().contains('income');

    return GlassContainer(
      borderRadius: 15,
      blur: 20,
      gradientColors: [
        Colors.white.withValues(alpha: 0.08),
        AppColors.primaryColor.withValues(alpha: 0.02),
        Colors.white.withValues(alpha: 0.04),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              4.heightBox,
              Icon(
                isIncome
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 18,
                color: amountColor.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Flexible(
                child:
                    Text(
                      title.trim().toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                    ).bodySmall(
                      color: Colors.white.withValues(alpha: 0.6),
                      weight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          4.heightBox,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(amount, textAlign: TextAlign.center).mono(
              fontSize: 18,
              weight: FontWeight.w600,
              color: amountColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
