import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/widgets/transaction_list_item.dart';
import 'package:personal_finance_tracker/widgets/transaction_type_toggle.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: () => MainNavScreen.navKey.currentState?.switchToHome(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Activity",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
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
                    final transactions = provider.transactions
                        .where((tx) => tx.isIncome == _isShowingIncome)
                        .toList();

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
                            final originalIndex = provider.transactions.indexOf(
                              tx,
                            );
                            provider.deleteTransaction(
                              tx.key as int,
                              originalIndex,
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTransactionScreen(transaction: tx),
                              ),
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
    );
  }
}
