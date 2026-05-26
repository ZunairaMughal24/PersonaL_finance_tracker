import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/shared/transaction_action_bar.dart';
import 'package:montage/widgets/shared/transaction_app_bar.dart';
import 'package:montage/widgets/history/history_list.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:montage/widgets/shared/transaction_filter_bar.dart';
import 'package:montage/widgets/shared/transaction_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/widgets/shared/transaction_section_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionListViewModel(
        context.read<TransactionProvider>(),
        isHistoryMode: true,
      ),
      child: const _HistoryScreenBody(),
    );
  }
}

class _HistoryScreenBody extends StatefulWidget {
  const _HistoryScreenBody();

  @override
  State<_HistoryScreenBody> createState() => _HistoryScreenBodyState();
}

class _HistoryScreenBodyState extends State<_HistoryScreenBody> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _selectionModalOpen = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    if (!_searchFocusNode.hasFocus && _isSearchVisible) {
      final vm = context.read<TransactionListViewModel>();
      if (vm.searchQuery.isEmpty) {
        setState(() {
          _isSearchVisible = false;
        });
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
        isHistoryMode: true,
        onPrimaryAction: () async {
          final count = vm.selectedCount;
          Navigator.pop(context);
          await vm.restoreSelected();
          if (context.mounted) {
            ToastUtils.show(
              context,
              "$count transaction${count > 1 ? 's' : ''} restored",
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
        title: 'History',
        isSearchVisible: _isSearchVisible,
        onShowBatchActions: () => _showBatchActionsSheet(vm),
        onToggleSearch: () => setState(() {
          _isSearchVisible = !_isSearchVisible;
          if (_isSearchVisible) {
            _searchFocusNode.requestFocus();
          } else {
            vm.updateSearch('');
            _searchFocusNode.unfocus();
          }
        }),
      ),
      body: AppBackground(
        style: BackgroundStyle.premiumHybrid,
        child: SafeArea(
          child: Column(
            children: [
              if (_isSearchVisible) ...[
                10.heightBox,
                TransactionSearchBar(
                  focusNode: _searchFocusNode,
                  hintText: 'Search history...',
                  onChanged: vm.updateSearch,
                  selectedDateRange: vm.selectedDateRange,
                  onDateRangeChanged: vm.setDateRange,
                ),
              ],
              if (_isSearchVisible) 10.heightBox else 4.heightBox,
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
                  title: "HISTORY EXPLORER",
                  subtitle:
                      vm.selectedCategory != null ||
                          vm.isIncomeFilter != null ||
                          vm.searchQuery.isNotEmpty
                      ? "Displaying Filtered Records"
                      : "All Archived Transactions",
                  badgeText: "${vm.filteredTransactions.length} RECORDS",
                ),
                8.heightBox,
              ],
              Expanded(child: HistoryList(vm: vm)),
            ],
          ),
        ),
      ),
    );
  }
}
