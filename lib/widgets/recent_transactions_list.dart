import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/transaction_list_item.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
import 'package:provider/provider.dart';

class RecentTransactionsList extends StatelessWidget {
  RecentTransactionsList({super.key});
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ValueListenableBuilder(
        valueListenable: db.listenToBox(),
        builder: (context, box, child) {
          final items = box.values.toList().reversed.toList();

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 50, color: AppColors.grey),
                  8.heightBox,
                  Text(
                    "No transactions yet",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.3),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.surface, thickness: 1.5, height: 1),
            itemBuilder: (context, index) {
              final tx = items[index];

              return TransactionListItem(
                transaction: tx,
                index: index,
                onDelete: () {
                  transaction.deleteTransaction(tx.key as int, index);
                  ToastUtils.show(
                    context,
                    'Transaction deleted',
                    isError: false,
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
    );
  }
}
