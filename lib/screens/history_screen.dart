import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/history/history_action_bar.dart';
import 'package:montage/widgets/history/history_app_bar.dart';
import 'package:montage/widgets/history/history_list.dart';
import 'package:montage/widgets/history/history_modals.dart';
import 'package:montage/widgets/shared/transaction_filter_bar.dart';
import 'package:montage/widgets/shared/transaction_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/core/utils/toast_utility.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HistoryViewModel(context.read<TransactionProvider>()),
      child: Consumer<HistoryViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: HistoryAppBar(
              isSearchVisible: _isSearchVisible,
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
                bottom: false,
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
                    16.heightBox,
                    TransactionFilterBar(
                      isIncomeFilter: vm.isIncomeFilter,
                      selectedCategory: vm.selectedCategory,
                      onTypeChanged: vm.setIsIncomeFilter,
                      onCategoryChanged: vm.setCategory,
                      transactionsForExport: vm.archivedTransactions,
                    ),
                    16.heightBox,
                    Expanded(child: HistoryList(vm: vm)),
                  ],
                ),
              ),
            ),

            bottomSheet: vm.isSelectionMode
                ? HistoryActionBar(
                    selectedCount: vm.selectedCount,
                    onRestore: () async {
                      await vm.restoreSelected();
                      if (context.mounted) {
                        ToastUtils.show(
                          context,
                          "${vm.selectedCount} transaction${vm.selectedCount > 1 ? 's' : ''} restored",
                          isError: false,
                        );
                      }
                    },
                    onExport: () {
                      final selectedTxs = vm.archivedTransactions
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
                    onDelete: () => HistoryModals.showDeleteConfirm(
                      context: context,
                      vm: vm,
                      keys: vm.selectedKeys.toList(),
                    ),
                    onCancel: vm.clearSelection,
                  )
                : null,
          );
        },
      ),
    );
  }
}
