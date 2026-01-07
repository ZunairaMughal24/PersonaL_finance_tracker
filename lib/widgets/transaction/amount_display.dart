import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';

class AmountDisplay extends StatelessWidget {
  final String amount;
  final String currency;
  final bool isIncome;
  final VoidCallback onTap;

  const AmountDisplay({
    super.key,
    required this.amount,
    required this.currency,
    required this.isIncome,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = CurrencyUtils.getCurrencySymbol(currency);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              "$symbol $amount",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isIncome ? AppColors.green : AppColors.red,
                shadows: [
                  BoxShadow(
                    color: (isIncome ? AppColors.green : AppColors.red)
                        .withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Text(
              "Tap to edit amount",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
