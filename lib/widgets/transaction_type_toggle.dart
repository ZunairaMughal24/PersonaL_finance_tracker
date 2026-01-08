import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';

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

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (width - 40) / 2,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.green.withOpacity(0.15)
                    : AppColors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome ? AppColors.green : AppColors.red,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isIncome ? AppColors.green : AppColors.red)
                        .withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
                            size: 16,
                            color: isIncome ? AppColors.green : AppColors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Income",
                            style: TextStyle(
                              color: isIncome
                                  ? AppColors.green
                                  : AppColors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                            size: 16,
                            color: !isIncome ? AppColors.red : AppColors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Expense",
                            style: TextStyle(
                              color: !isIncome ? AppColors.red : AppColors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
