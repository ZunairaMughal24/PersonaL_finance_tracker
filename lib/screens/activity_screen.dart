import 'package:flutter/material.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';
import 'package:montage/widgets/activity/activity_empty_state.dart';
import 'package:montage/widgets/shared/transaction_search_bar.dart';
import 'package:montage/widgets/shared/transaction_filter_bar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<TransactionProvider>(context);
    final filter = Provider.of<TransactionFilterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Activity',
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                  if (_isSearchVisible) {
                    _searchFocusNode.requestFocus();
                  } else {
                    filter.setSearchQuery('');
                    _searchFocusNode.unfocus();
                  }
                });
              },
              icon: Icon(
                _isSearchVisible ? Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
                  hintText: 'Search transactions...',
                  onChanged: filter.setSearchQuery,
                  selectedDateRange: filter.selectedDateRange,
                  onDateRangeChanged: filter.setDateRange,
                ),
              ],
              16.heightBox,
              TransactionFilterBar(
                isIncomeFilter: filter.isIncomeFilter,
                selectedCategory: filter.selectedCategory,
                onTypeChanged: filter.setIsIncomeFilter,
                onCategoryChanged: filter.setCategory,
                transactionsForExport: filter.filterTransactions(
                  transaction.transactions,
                ),
              ),
              16.heightBox,
              Expanded(
                child: Consumer<UserSettingsProvider>(
                  builder: (context, settings, _) {
                    final filtered = filter.filterTransactions(
                      transaction.transactions,
                    );

                    if (filtered.isEmpty) return const ActivityEmptyState();

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tx = filtered[index];
                        return TransactionListItem(
                          transaction: tx,
                          currency: settings.selectedCurrency,
                          onDelete: () {
                            final originalIndex = transaction.transactions
                                .indexOf(tx);
                            transaction.deleteTransaction(
                              tx.key as int,
                              originalIndex,
                            );
                          },
                          onEdit: () {
                            context.push(
                              AppRoutes.editTransactionScreenRoute,
                              extra: tx,
                            );
                          },
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
