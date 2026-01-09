import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
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
      blur: 15,
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
                color: amountColor.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Text(title.trim().toUpperCase()).bodySmall(
                color: Colors.white.withOpacity(0.6),
                weight: FontWeight.bold,
              ),
            ],
          ),
          4.heightBox,
          Text(amount, textAlign: TextAlign.center).mono(
            fontSize: 18,
            weight: FontWeight.w600,
            color: amountColor.withOpacity(0.9),
          ),
        ],
      ),
    );
  }
}
