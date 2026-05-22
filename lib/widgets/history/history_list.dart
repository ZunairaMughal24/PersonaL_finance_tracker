import 'package:flutter/material.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/history/history_list_item.dart';
import 'package:montage/widgets/history/history_modals.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  final HistoryViewModel vm;

  const HistoryList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<UserSettingsProvider>();
    final archived = vm.archivedTransactions;

    if (archived.isEmpty) {
      return HistoryEmptyState(isSearching: vm.searchQuery.isNotEmpty);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: archived.length,
      itemBuilder: (context, index) {
        final tx = archived[index];
        return HistoryListItem(
          transaction: tx,
          currency: settings.selectedCurrency,
          isSelected: vm.selectedKeys.contains(tx.key),
          isSelectionMode: vm.isSelectionMode,
          onToggleSelection: vm.toggleSelection,
          onRestore: (key) {
            vm.restoreSingle(key);
            ToastUtils.show(context, "Transaction restored");
          },
          onDeletePermanently: (key) => HistoryModals.showDeleteConfirm(
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
