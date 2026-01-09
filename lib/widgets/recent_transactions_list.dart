import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/widgets/transaction/transaction_list_item.dart';
import 'package:personal_finance_tracker/core/utils/toast_utility.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:personal_finance_tracker/widgets/glass_container.dart';

class RecentTransactionsList extends StatelessWidget {
  RecentTransactionsList({super.key});
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      borderRadius: 24,
      blur: 15,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ValueListenableBuilder(
          valueListenable: db.listenToBox(),
          builder: (context, box, child) {
            final items = box.values.toList().reversed.toList();

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 48,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "No transactions yet",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.05),
                thickness: 1,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
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
    );
  }
}
