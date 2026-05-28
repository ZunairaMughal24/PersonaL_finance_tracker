import 'package:flutter/material.dart';
import 'package:montage/widgets/shared/selectable_transaction_list_item.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/shared/transaction_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/widgets/activity/activity_empty_state.dart';
import 'package:montage/widgets/shared/transaction_search_bar.dart';
import 'package:montage/widgets/shared/transaction_filter_bar.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/shared/transaction_action_bar.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/widgets/shared/transaction_section_header.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ActivityScreenBody();
  }
}

class _ActivityScreenBody extends StatefulWidget {
  const _ActivityScreenBody();

  @override
  State<_ActivityScreenBody> createState() => _ActivityScreenBodyState();
}

class _ActivityScreenBodyState extends State<_ActivityScreenBody> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _selectionModalOpen = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    // If the keyboard is dismissed/focus lost and there's no text, close the search bar
    if (!_searchFocusNode.hasFocus) {
      final vm = context.read<TransactionListViewModel>();
      if (vm.isSearchVisible && vm.searchQuery.isEmpty) {
        vm.toggleSearch();
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showBatchActionsSheet(TransactionListViewModel vm) {
    if (_selectionModalOpen) return;
    _selectionModalOpen = true;
    AppBottomSheet.show(
      context: context,
      child: TransactionActionBar(
        selectedCount: vm.selectedCount,
        isHistoryMode: false,
        onPrimaryAction: () async {
          final count = vm.selectedCount;
          Navigator.pop(context);
          await vm.archiveSelected();
          if (context.mounted) {
            ToastUtils.show(
              context,
              "$count transaction${count > 1 ? 's' : ''} deleted",
              isError: false,
            );
          }
        },
        onExport: () {
          Navigator.pop(context);
          final selectedTxs = vm.filteredTransactions
              .where((tx) => vm.selectedKeys.contains(tx.key))
              .toList();
          final settings = context.read<UserSettingsProvider>();
          ExportBottomSheet.show(
            context: context,
            transactions: selectedTxs,
            userName: settings.userName,
            currency: settings.selectedCurrency,
          );
        },
        onDelete: () {
          Navigator.pop(context);
          TransactionModals.showDeleteConfirm(
            context: context,
            vm: vm,
            keys: vm.selectedKeys.toList(),
          );
        },
        onCancel: () {
          Navigator.pop(context);
          vm.clearSelection();
        },
      ),
    ).then((_) {
      _selectionModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionListViewModel>();

    // Automatic dismissal only (if count becomes zero while modal is open)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectionModalOpen && vm.selectedCount == 0) {
        Navigator.pop(context);
        _selectionModalOpen = false;
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: TransactionAppBar(
        title: 'Activity',
        isSearchVisible: vm.isSearchVisible,
        onShowBatchActions: () => _showBatchActionsSheet(vm),
        onToggleSearch: () {
          vm.toggleSearch();
          if (vm.isSearchVisible) {
            _searchFocusNode.requestFocus();
          } else {
            _searchFocusNode.unfocus();
          }
        },
      ),
      body: AppBackground(
        style: BackgroundStyle.premiumHybrid,
        child: SafeArea(
          child: Column(
            children: [
              if (vm.isSearchVisible) ...[
                10.heightBox,
                TransactionSearchBar(
                  focusNode: _searchFocusNode,
                  hintText: 'Search transactions...',
                  onChanged: vm.updateSearch,
                  selectedDateRange: vm.selectedDateRange,
                  onDateRangeChanged: vm.setDateRange,
                ),
              ],
              if (vm.isSearchVisible) 10.heightBox else 4.heightBox,
              const TransactionSectionHeader(title: "QUICK FILTERS"),
              TransactionFilterBar(
                isIncomeFilter: vm.isIncomeFilter,
                selectedCategory: vm.selectedCategory,
                onTypeChanged: vm.setIsIncomeFilter,
                onCategoryChanged: vm.setCategory,
                transactionsForExport: vm.selectedCount > 0
                    ? vm.filteredTransactions
                          .where((tx) => vm.selectedKeys.contains(tx.key))
                          .toList()
                    : vm.filteredTransactions,
              ),
              if (vm.filteredTransactions.isNotEmpty) ...[
                12.heightBox,
                TransactionSectionHeader(
                  title: "DETAILED ACTIVITY",
                  subtitle:
                      vm.selectedCategory != null ||
                          vm.isIncomeFilter != null ||
                          vm.searchQuery.isNotEmpty
                      ? "Filtered Results"
                      : "Recent Transactions",
                  badgeText: "${vm.filteredTransactions.length} RECORDS",
                ),
                8.heightBox,
              ],
              Expanded(
                child: Consumer<UserSettingsProvider>(
                  builder: (context, settings, _) {
                    final filtered = vm.filteredTransactions;

                    if (filtered.isEmpty) {
                      return ActivityEmptyState(
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
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tx = filtered[index];
                        return SelectableTransactionListItem(
                          transaction: tx,
                          currency: settings.selectedCurrency,
                          isSelected: vm.selectedKeys.contains(tx.key),
                          isSelectionMode: vm.isSelectionMode,
                          isHistoryMode: false,
                          onToggleSelection: (key) => vm.toggleSelection(key),
                          onPrimaryAction: (key) {
                            context.push(
                              AppRoutes.editTransactionScreenRoute,
                              extra: tx,
                            );
                          },
                          onDelete: (key) => vm.deleteSingleTransaction(key),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
