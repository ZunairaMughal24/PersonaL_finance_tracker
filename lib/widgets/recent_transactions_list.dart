import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/constants/appColors.dart';
import 'package:personal_finance_tracker/core/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_list_item.dart';
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
        color: const Color.fromARGB(255, 44, 51, 86),
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
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                Divider(color: AppColors.surface, height: 1.2),
            itemBuilder: (context, index) {
              final tx = items[index];

              return TransactionListItem(
                transaction: tx,
                onDelete: () {
                  transaction.deleteTransaction(tx.key as int, index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transaction deleted')),
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
