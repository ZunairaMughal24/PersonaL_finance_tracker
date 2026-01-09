import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_list_item.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/widgets/app_background.dart';
import 'package:personal_finance_tracker/widgets/custom_app_bar.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _isShowingIncome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Activity",
        onLeadingTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                TransactionTypeToggle(
                  isIncome: _isShowingIncome,
                  onChanged: (val) {
                    setState(() {
                      _isShowingIncome = val;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Consumer<TransactionProvider>(
                    builder: (context, provider, child) {
                      final transactions = provider.getTransactionsByType(
                        _isShowingIncome,
                      );

                      if (transactions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isShowingIncome
                                    ? Icons.account_balance_wallet_outlined
                                    : Icons.receipt_long_outlined,
                                size: 64,
                                color: AppColors.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No ${_isShowingIncome ? 'income' : 'expense'} recorded",
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.white.withOpacity(0.1),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final tx = transactions[index];

                          return TransactionListItem(
                            transaction: tx,
                            index: index,
                            onDelete: () {
                              final originalIndex = provider.transactions
                                  .indexOf(tx);
                              provider.deleteTransaction(
                                tx.key as int,
                                originalIndex,
                              );
                            },
                            onEdit: () {
                              context.push(
                                AppRoutes.editTransactionScreenRoute,
                                extra: tx,
                              );
                            },
                          );
                        },
                      );
                    },
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
