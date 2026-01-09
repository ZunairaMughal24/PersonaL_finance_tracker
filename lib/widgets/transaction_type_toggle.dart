import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/widgets/glass_container.dart';

class TransactionTypeToggle extends StatelessWidget {
  final bool isIncome;
  final Function(bool) onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GlassContainer(
      width: width,
      height: 52,
      borderRadius: 16,
      blur: 10,
      gradientColors: [
        Colors.white.withOpacity(0.08),
        Colors.white.withOpacity(0.02),
      ],
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (width - 40) / 2,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.green.withOpacity(0.2)
                    : AppColors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isIncome ? AppColors.green : AppColors.red)
                      .withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isIncome ? AppColors.green : AppColors.red)
                        .withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isIncome) onChanged(true);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: isIncome
                                ? AppColors.green
                                : Colors.white.withOpacity(0.4),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Income",
                            style: TextStyle(
                              color: isIncome
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              fontWeight: isIncome
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isIncome) onChanged(false);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 18,
                            color: !isIncome
                                ? AppColors.red
                                : Colors.white.withOpacity(0.4),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Expense",
                            style: TextStyle(
                              color: !isIncome
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              fontWeight: !isIncome
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
