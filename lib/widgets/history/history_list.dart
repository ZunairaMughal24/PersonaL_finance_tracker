import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/shared/selectable_transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryList extends StatelessWidget {
  final TransactionListViewModel vm;
  final bool isArchiveMode;

  const HistoryList({
    super.key,
    required this.vm,
    this.isArchiveMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<UserSettingsProvider>();
    final items = vm.filteredTransactions;

    if (items.isEmpty) {
      return HistoryEmptyState(
        isArchiveMode: isArchiveMode,
        hasFilters:
            vm.searchQuery.isNotEmpty ||
            vm.selectedCategory != null ||
            vm.isIncomeFilter != null,
        onClearFilters: () {
          vm.updateSearch('');
          vm.setCategory(null);
          vm.setIsIncomeFilter(null);
        },
      );
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final tx = items[index];
          return SelectableTransactionListItem(
            transaction: tx,
            currency: settings.selectedCurrency,
            isSelected: vm.selectedIds.contains(tx.id),
            isSelectionMode: vm.isSelectionMode,
            isHistoryMode: !isArchiveMode,
            isArchiveMode: isArchiveMode,
            onToggleSelection: (key) => vm.toggleSelection(key),
            onPrimaryAction: (key) async {
              await vm.restoreSingleTransaction(key);
              if (context.mounted) {
                ToastUtils.show(context, 'Transaction restored', isError: false);
              }
            },
            // Confirmation already shown by swipe — directly delete here to avoid double sheet.
            onDelete: (key) async {
              await vm.deleteSinglePermanently(key);
              if (context.mounted) {
                ToastUtils.show(context, 'Transaction permanently deleted', isError: true);
              }
            },
            onArchive: isArchiveMode
                ? (key) async {
                    await vm.deleteSingleTransaction(key);
                    if (context.mounted) {
                      ToastUtils.show(context, 'Moved to History', isError: false);
                    }
                  }
                : null,
          );
        },
      ),
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  final bool hasFilters;
  final bool isArchiveMode;
  final VoidCallback? onClearFilters;

  const HistoryEmptyState({
    super.key,
    required this.hasFilters,
    this.isArchiveMode = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final emptyTitle = isArchiveMode ? 'Archive is empty' : 'History is empty';
    final emptySubtitle = isArchiveMode
        ? 'Archived transactions appear here'
        : 'Deleted items will appear here';

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
                    : isArchiveMode
                        ? Icons.archive_rounded
                        : Icons.history_rounded,
                size: 32,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            24.heightBox,
            Text(
              hasFilters
                  ? (isArchiveMode ? 'No matches in archive' : 'No matches in history')
                  : emptyTitle,
              textAlign: TextAlign.center,
            ).bodyLarge(
              color: Colors.white.withValues(alpha: 0.6),
              weight: FontWeight.w600,
            ),
            4.heightBox,
            Text(
              hasFilters ? 'Try adjusting your filters' : emptySubtitle,
              textAlign: TextAlign.center,
            ).bodyLarge(color: Colors.white.withValues(alpha: 0.25)),
            if (hasFilters && onClearFilters != null) ...[
              24.heightBox,
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Clear all filters'),
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
