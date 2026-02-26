import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/widgets/balance_card.dart';
import 'package:personal_finance_tracker/widgets/home_header.dart';
import 'package:personal_finance_tracker/widgets/recent_transactions_list.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/utils/currency_utils.dart';
import 'package:personal_finance_tracker/core/themes/textTheme_extention.dart';
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          color: Colors.white.withOpacity(0.7),
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    12.heightBox,
                    Selector<TransactionProvider, double>(
                      selector: (_, p) => p.totalBalance,
                      builder: (context, balance, _) =>
                          TotalBalanceCard(totalBalance: balance),
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
                    6.heightBox,
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
                            foregroundColor: Colors.white.withOpacity(0.7),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'See All',
                          ).labelLarge(weight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
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

class _AIInsightsSection extends StatelessWidget {
  final TransactionProvider txProvider;

  const _AIInsightsSection({required this.txProvider});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: txProvider.insightsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(24),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds),
          );
        }

        final insights = snapshot.data ?? txProvider.cachedInsightsValue;
        if (insights == null || insights.isEmpty)
          return const SizedBox.shrink();

        return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.02),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .shimmer(
                                  duration: 4.seconds,
                                  color: Colors.white24,
                                ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                insights,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 1000.ms)
            .slideX(begin: 0.05, curve: Curves.easeOut);
      },
    );
  }
}
