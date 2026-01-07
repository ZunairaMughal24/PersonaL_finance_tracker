import 'package:flutter/material.dart';

import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class TotalBalanceCard extends StatelessWidget {
  final String formattedBalance;

  const TotalBalanceCard({super.key, required this.formattedBalance});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.transactionCardGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          13.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.white,
                size: 20,
              ),
            ],
          ),
          8.heightBox,
          Text(
            formattedBalance,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          6.heightBox,
          Text(
            'As of ${today.day}-${today.month}-${today.year}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
