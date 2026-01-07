import 'package:flutter/material.dart';

import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

class TotalBalanceCard extends StatelessWidget {
  final double balance;

  const TotalBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.black,
                size: 20,
              ),
            ],
          ),
          14.heightBox,
          Center(
            child: Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          12.heightBox,
          Text(
            'As of ${today.day}-${today.month}-${today.year}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
