import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/contants/appColors.dart';
import 'package:personal_finance_tracker/core/contants/utils/widget_utility_extention.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/menu_bar.dart';
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey, width: 1),
      ),
      child: ValueListenableBuilder(
        valueListenable: db.listenToBox(),
        builder: (context, value, child) {
          final items = db.getAllTransaction();

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
                      color: AppColors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          //Otherwise show list of transactions
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final tx = items[index];

              return ListTile(
                leading: Icon(
                  Icons.monetization_on,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  tx.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                subtitle: Text(
                  tx.isIncome ? 'Income' : 'Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$${tx.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: tx.isIncome
                                ? AppColors.green
                                : AppColors.red,
                          ),
                        ),
                        2.heightBox,
                        Text(
                          tx.date,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    PopUpMenu(
                      onItemSelected: (value) {
                        if (value == 'Delete') {
                          transaction.deleteTransaction(tx.key as int);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transaction deleted')),
                          );
                        } else if (value == 'Edit') {
                 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditTransactionScreen(),
  ),
);
                        } else if (value == 'Detail') {
                          // Navigator.pushNamed(context, AppRoutes.detailTransactionScreenRoute);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
