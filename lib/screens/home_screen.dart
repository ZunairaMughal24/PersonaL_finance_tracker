import "package:flutter/material.dart";

import 'package:personal_finance_tracker/core/constants/appColors.dart';

import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import "package:personal_finance_tracker/widgets/balance_card.dart";
import "package:personal_finance_tracker/widgets/info_card.dart";
import "package:personal_finance_tracker/widgets/home_header.dart";
import "package:personal_finance_tracker/widgets/recent_transactions_list.dart";
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';

import 'package:personal_finance_tracker/core/utils/currency_utils.dart'; // Add import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    final symbol = CurrencyUtils.getCurrencySymbol(transaction.displayCurrency);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.homeGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(
                  userName: 'Zunaira',
                  summaryText: "Here's Your financial summary",
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TotalBalanceCard(
                        formattedBalance:
                            "$symbol ${transaction.totalBalance.ceilToDouble().toStringAsFixed(2)}",
                      ),
                      20.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InfoBox(
                            title: " Total Income",
                            amount:
                                "$symbol ${transaction.totalIncome.toStringAsFixed(2)}",
                            amountColor: AppColors.green,
                          ),
                          InfoBox(
                            title: " Total Expense",
                            amount:
                                "$symbol ${transaction.totalExpense.toStringAsFixed(2)}",
                            amountColor: AppColors.red,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRoutes.activityScreenRoute);
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      RecentTransactionsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
