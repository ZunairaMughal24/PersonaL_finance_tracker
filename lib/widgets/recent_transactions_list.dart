import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/config/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/padding_extention.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final transactions = transactionProvider.transactions;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            12.heightBox,
            Text(
              "No transactions yet",
            ).bodySmall(color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ).py(20);
    }

    final itemCount = transactions.length > 5 ? 5 : transactions.length;

    return Consumer<UserSettingsProvider>(
      builder: (context, settings, _) => ListView.separated(
        padding: const EdgeInsets.only(bottom: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          // Efficiently access the latest transactions without reversing the whole list
          final tx = transactions[transactions.length - 1 - index];
          return TransactionListItem(
            transaction: tx,
            currency: settings.selectedCurrency,
            onDelete: () {
              // Get the actual index in the original list for deletion
              final actualIndex = transactions.length - 1 - index;
              transactionProvider.deleteTransaction(tx.key as int, actualIndex);
              ToastUtils.show(
                context,
                'Transaction deleted',
                isError: false,
              );
            },
            onEdit: () {
              context.push(AppRoutes.editTransactionScreenRoute, extra: tx);
            },
          );
        },
      ),
    );
  }
}
