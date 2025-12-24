import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:personal_finance_tracker/config/router.dart";

import 'package:personal_finance_tracker/core/contants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import "package:personal_finance_tracker/widgets/balance_card.dart";
import "package:personal_finance_tracker/widgets/info_card.dart";
import "package:personal_finance_tracker/widgets/recent_transactions_list.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.transactionScreenRoute);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.grey, thickness: 1),
          10.heightBox,
          TotalBalanceCard(balance: transaction.totalBalance.ceilToDouble()),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoBox(
                title: " Total Income",
                amount: "${transaction.totalIncome.toStringAsFixed(2)}",
                amountColor: AppColors.green,
              ),
              InfoBox(
                title: " Total Expense",
                amount: "${transaction.totalExpense.toStringAsFixed(2)}",
                amountColor: AppColors.red,
              ),
            ],
          ),
          8.heightBox,
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
          10.heightBox,
          RecentTransactionsList(),
        ],
      ).px16(),
    );
  }
}
