import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:montage/widgets/balance_card.dart';
import 'package:montage/widgets/home_header.dart';
import 'package:montage/widgets/recent_transactions_list.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/padding_extention.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/ai_insights_card.dart';
import 'package:montage/widgets/home_skeleton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.premiumHybrid,
      child: SafeArea(
        child: Consumer2<TransactionProvider, UserSettingsProvider>(
          builder: (context, tx, settings, _) {
            if (!tx.isReady || !settings.isReady) {
              return const HomeSkeleton();
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    userName: settings.userName,
                    profileImagePath: settings.profileImagePath,
                    summaryText: "Your financial dashboard",
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
                        TotalBalanceCard(
                          totalBalance: tx.totalBalance,
                          hasEntries: tx.transactions.isNotEmpty,
                        ),
                        20.heightBox,
                        Row(
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
                        4.heightBox,
                        AIInsightsCard(txProvider: tx),
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
            );
          },
        ),
      ),
    );
  }
}
