import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/app_colors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/widgets/balance_card.dart';
import 'package:personal_finance_tracker/widgets/home_header.dart';
import 'package:personal_finance_tracker/widgets/recent_transactions_list.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/text_theme_extension.dart';
import 'package:personal_finance_tracker/core/utils/padding_extention.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/ai_insights_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.premiumHybrid,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<UserSettingsProvider, (String, String?)>(
                selector: (_, p) => (p.userName, p.profileImagePath),
                builder: (context, data, _) => HomeHeader(
                  userName: data.$1,
                  profileImagePath: data.$2,
                  summaryText: "Your financial dashboard",
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overview',
                        ).h2(color: Colors.white, weight: FontWeight.bold),
                        Text('Your current financial status').bodyMedium(
                          color: Colors.white.withValues(alpha: 0.8),
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    12.heightBox,
                    Selector<TransactionProvider, (double, bool)>(
                      selector: (_, p) =>
                          (p.totalBalance, p.transactions.isNotEmpty),
                      builder: (context, data, _) => TotalBalanceCard(
                        totalBalance: data.$1,
                        hasEntries: data.$2,
                      ),
                    ),
                    20.heightBox,
                    Consumer2<UserSettingsProvider, TransactionProvider>(
                      builder: (context, settings, tx, _) => Row(
                        children: [
                          Expanded(
                            child: InfoBox(
                              title: "Income",
                              amount: CurrencyUtils.formatAmount(
                                tx.totalIncome,
                                settings.selectedCurrency,
                              ),
                              amountColor: AppColors.green,
                            ),
                          ),
                          16.widthBox,
                          Expanded(
                            child: InfoBox(
                              title: "Expenses",
                              amount: CurrencyUtils.formatAmount(
                                tx.totalExpense,
                                settings.selectedCurrency,
                              ),
                              amountColor: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    4.heightBox,
                    Consumer<TransactionProvider>(
                      builder: (context, tx, _) =>
                          AIInsightsCard(txProvider: tx),
                    ),
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
                            foregroundColor: Colors.white.withValues(
                              alpha: 0.7,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'See All',
                          ).labelLarge(weight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ).pOnly(bottom: 2),
              ),
              RecentTransactionsList().px16(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
