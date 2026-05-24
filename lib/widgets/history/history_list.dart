import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/shared/selectable_transaction_list_item.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  final TransactionListViewModel vm;

  const HistoryList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<UserSettingsProvider>();
    final archived = vm.filteredTransactions;

    if (archived.isEmpty) {
      return HistoryEmptyState(isSearching: vm.searchQuery.isNotEmpty);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: archived.length,
      itemBuilder: (context, index) {
        final tx = archived[index];
        return SelectableTransactionListItem(
          transaction: tx,
          currency: settings.selectedCurrency,
          isSelected: vm.selectedKeys.contains(tx.key),
          isSelectionMode: vm.isSelectionMode,
          isHistoryMode: true,
          onToggleSelection: (key) => vm.toggleSelection(key),
          onPrimaryAction: (key) {
            vm.restoreSelected(); // Or a restoreSingle if we had one
            ToastUtils.show(
              context,
              "Transaction successfully restored",
              isError: false,
            );
          },
          onDelete: (key) => TransactionModals.showDeleteConfirm(
            context: context,
            vm: vm,
            keys: [key],
          ),
        );
      },
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  final bool isSearching;

  const HistoryEmptyState({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.history_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          16.heightBox,
          Text(
            isSearching
                ? "No transactions match your search"
                : "No archived transactions",
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
