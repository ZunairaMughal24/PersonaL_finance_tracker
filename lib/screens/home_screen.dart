import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/viewmodels/home_view_model.dart';
import 'package:montage/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:montage/widgets/balance_card.dart';
import 'package:montage/widgets/home_header.dart';
import 'package:montage/widgets/recent_transactions_list.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/padding_extention.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/ai_insights_card.dart';
import 'package:montage/widgets/home_skeleton.dart';
import 'package:montage/widgets/shared/transaction_section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      style: BackgroundStyle.premiumHybrid,
      child: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            if (!vm.isReady) return const HomeSkeleton();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    userName: vm.userName,
                    profileImagePath: vm.profileImagePath,
                    summaryText: "Your financial dashboard",
                  ),
                  const SizedBox(height: 8),
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
                              color: Colors.white.withValues(alpha: 0.8),
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        12.heightBox,
                        TotalBalanceCard(
                          totalBalance: vm.totalBalance,
                          hasEntries: vm.hasEntries,
                        ),
                        20.heightBox,
                        Row(
                          children: [
                            Expanded(
                              child: InfoBox(
                                title: "Income",
                                amount: vm.formattedIncome,
                                amountColor: AppColors.green,
                              ),
                            ),
                            16.widthBox,
                            Expanded(
                              child: InfoBox(
                                title: "Expenses",
                                amount: vm.formattedExpense,
                                amountColor: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                        12.heightBox,
                        const TransactionSectionHeader(
                          title: "SMART ANALYSIS",
                          subtitle: "AI-powered financial insights",
                          horizontalPadding: 0,
                        ),
                        AIInsightsCard(vm: vm),
                        8.heightBox,
                        TransactionSectionHeader(
                          title: "RECENT ACTIVITY",
                          subtitle: "Your latest transactions",
                          horizontalPadding: 0,
                          trailing: TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.activityScreenRoute),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withValues(
                                alpha: 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.padded,
                            ),
                            child: const Text(
                              'See All',
                            ).labelLarge(weight: FontWeight.w600),
                          ),
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
