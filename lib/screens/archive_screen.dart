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

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionListViewModel(
        context.read<TransactionProvider>(),
        isHistoryMode: false,
        isArchiveMode: true,
      ),
      child: const _ArchiveScreenBody(),
    );
  }
}

class _ArchiveScreenBody extends StatefulWidget {
  const _ArchiveScreenBody();

  @override
  State<_ArchiveScreenBody> createState() => _ArchiveScreenBodyState();
}

class _ArchiveScreenBodyState extends State<_ArchiveScreenBody> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _selectionModalOpen = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus && _isSearchVisible) {
      final vm = context.read<TransactionListViewModel>();
      if (vm.searchQuery.isEmpty) {
        setState(() => _isSearchVisible = false);
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
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
          if (mounted) {
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
              .where((tx) => vm.selectedIds.contains(tx.id))
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
          final count = vm.selectedCount;
          Navigator.pop(context);
          TransactionModals.showDeleteConfirm(
            context: context,
            count: count,
            onConfirm: () async {
              await vm.deleteSelected();
              if (context.mounted) {
                ToastUtils.show(context, "$count transaction${count > 1 ? 's' : ''} deleted permanently", isError: true);
              }
            },
          );
        },
        onCancel: () {
          Navigator.pop(context);
          vm.clearSelection();
        },
      ),
    ).then((_) => _selectionModalOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionListViewModel>();

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
        title: 'Archive',
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
                  hintText: 'Search archive...',
                  onChanged: vm.updateSearch,
                  selectedDateRange: vm.selectedDateRange,
                  onDateRangeChanged: vm.setDateRange,
                ),
              ],
              if (_isSearchVisible) 10.heightBox else 4.heightBox,
              const TransactionSectionHeader(title: 'QUICK FILTERS'),
              TransactionFilterBar(
                isIncomeFilter: vm.isIncomeFilter,
                selectedCategory: vm.selectedCategory,
                onTypeChanged: vm.setIsIncomeFilter,
                onCategoryChanged: vm.setCategory,
                transactionsForExport: vm.selectedCount > 0
                    ? vm.filteredTransactions
                          .where((tx) => vm.selectedIds.contains(tx.id))
                          .toList()
                    : vm.filteredTransactions,
              ),
              if (vm.filteredTransactions.isNotEmpty) ...[
                12.heightBox,
                TransactionSectionHeader(
                  title: 'ARCHIVE',
                  subtitle: vm.selectedCategory != null ||
                          vm.isIncomeFilter != null ||
                          vm.searchQuery.isNotEmpty
                      ? 'Filtered Results'
                      : 'Archived Transactions',
                  badgeText: '${vm.filteredTransactions.length} RECORDS',
                ),
                8.heightBox,
              ],
              Expanded(
                child: HistoryList(vm: vm, isArchiveMode: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
