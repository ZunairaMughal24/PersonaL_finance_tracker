import "package:flutter/material.dart";

import 'package:personal_finance_tracker/core/constants/appColors.dart';

import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/info_card.dart';
import 'package:provider/provider.dart';
import "package:personal_finance_tracker/widgets/balance_card.dart";

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              // Previous: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80',
              'https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80', // 3D Abstract Geometric
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.background),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(
                    userName: 'Zunaira',
                    summaryText: "Your financial dashboard",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Your current financial status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TotalBalanceCard(
                          formattedBalance: CurrencyUtils.formatAmount(
                            transaction.totalBalance,
                            transaction.displayCurrency,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: InfoBox(
                                title: "Income",
                                amount: CurrencyUtils.formatAmount(
                                  transaction.totalIncome,
                                  transaction.displayCurrency,
                                ),
                                amountColor: AppColors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InfoBox(
                                title: "Expenses",
                                amount: CurrencyUtils.formatAmount(
                                  transaction.totalExpense,
                                  transaction.displayCurrency,
                                ),
                                amountColor: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push(AppRoutes.activityScreenRoute),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryLight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        RecentTransactionsList(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
