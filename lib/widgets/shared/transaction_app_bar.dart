import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:provider/provider.dart';

class TransactionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;
  final VoidCallback? onShowBatchActions;
  final String title;

  const TransactionAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onToggleSearch,
    required this.title,
    this.onShowBatchActions,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionListViewModel>();
    final transactions = vm.filteredTransactions;

    return AppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        vm.isSelectionMode ? '${vm.selectedCount} Selected' : title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          fontSize: 19,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (vm.isSelectionMode) ...[
          if (vm.selectedCount > 0)
            IconButton(
              icon: const Icon(
                Icons.bolt_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: onShowBatchActions,
              tooltip: 'Batch Actions',
            ),
          IconButton(
            icon: Icon(
              vm.selectedCount == transactions.length
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () => vm.selectedCount == transactions.length
                ? vm.deselectAll()
                : vm.selectAll(),
          ),
        ] else
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            offset: const Offset(0, 48),
            onSelected: (val) {
              if (val == 'search') {
                onToggleSearch();
              } else if (val == 'select' && transactions.isNotEmpty) {
                vm.enterSelectionMode();
              } else if (val == 'restore_all' || val == 'clear_dashboard') {
                if (vm.isHistoryMode) {
                  TransactionModals.showRestoreAllConfirm(
                    context: context,
                    vm: vm,
                  );
                } else {
                  TransactionModals.showArchiveAllConfirm(
                    context: context,
                    vm: vm,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(
                      isSearchVisible
                          ? Icons.search_off_rounded
                          : Icons.search_rounded,
                      size: 20,
                      color: isSearchVisible
                          ? AppColors.primaryColor
                          : Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    Text(isSearchVisible ? 'Close Search' : 'Search'),
                  ],
                ),
              ),
              if (transactions.isNotEmpty)
                PopupMenuItem(
                  value: 'select',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      const Text('Select Items'),
                    ],
                  ),
                ),
              if (transactions.isNotEmpty)
                PopupMenuItem(
                  value: vm.isHistoryMode ? 'restore_all' : 'clear_dashboard',
                  child: Row(
                    children: [
                      Icon(
                        vm.isHistoryMode
                            ? Icons.settings_backup_restore_rounded
                            : Icons.delete_sweep_rounded,
                        size: 20,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      Text(vm.isHistoryMode ? 'Restore All' : 'Delete All'),
                    ],
                  ),
                ),
            ],
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.12),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
