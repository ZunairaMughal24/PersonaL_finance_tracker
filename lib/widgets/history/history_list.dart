import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/providers/transaction_provider.dart';
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
      return HistoryEmptyState(
        hasFilters:
            vm.searchQuery.isNotEmpty ||
            vm.selectedCategory != null ||
            vm.isIncomeFilter != null,
        onClearFilters: () {
          vm.updateSearch("");
          vm.setCategory(null);
          vm.setIsIncomeFilter(null);
        },
      );
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
          onPrimaryAction: (key) async {
            await context.read<TransactionProvider>().restoreTransactions([
              key,
            ]);
            if (context.mounted) {
              ToastUtils.show(context, "Transaction restored", isError: false);
            }
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
  final bool hasFilters;
  final VoidCallback? onClearFilters;

  const HistoryEmptyState({
    super.key,
    required this.hasFilters,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters
                    ? Icons.filter_list_off_rounded
                    : Icons.history_rounded,
                size: 32,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            24.heightBox,
            Text(
              hasFilters ? "No matches in history" : "History is empty",
              textAlign: TextAlign.center,
            ).bodyLarge(
              color: Colors.white.withValues(alpha: 0.6),
              weight: FontWeight.w600,
            ),
            4.heightBox,
            Text(
              hasFilters
                  ? "Try adjusting your filters"
                  : "Deleted items will appear here",
              textAlign: TextAlign.center,
            ).bodyLarge(color: Colors.white.withValues(alpha: 0.25)),
            if (hasFilters && onClearFilters != null) ...[
              24.heightBox,
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text("Clear all filters"),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
