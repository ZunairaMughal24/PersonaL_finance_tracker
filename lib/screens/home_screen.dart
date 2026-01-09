import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/widgets/balance_card.dart';
import 'package:personal_finance_tracker/widgets/home_header.dart';
import 'package:personal_finance_tracker/widgets/recent_transactions_list.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';

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
              'https://images.unsplash.com/photo-1635776062127-d379bfcba9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80',
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
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overview',
                          ).h2(color: Colors.white, weight: FontWeight.bold),
                          Text('Your current financial status').bodyMedium(
                            color: Colors.white.withOpacity(0.7),
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                      12.heightBox,
                      TotalBalanceCard(
                        formattedBalance: CurrencyUtils.formatAmount(
                          transaction.totalBalance,
                          transaction.displayCurrency,
                        ),
                      ),
                      20.heightBox,
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
                          16.widthBox,
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
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Activity').titleLarge(
                            color: Colors.white,
                            weight: FontWeight.bold,
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
                            ).labelLarge(weight: FontWeight.w600),
                          ),
                        ],
                      ),
                      2.heightBox,
                      RecentTransactionsList(),
                      24.heightBox,
                    ],
                  ).px16(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
