import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/config/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/transaction_type_toggle.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

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
        title: 'Activity Screen',
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
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < -200) {
              filter.setIsIncomeFilter(false);
            } else if (details.primaryVelocity! > 200) {
              filter.setIsIncomeFilter(true);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                if (_isSearchVisible) ...[
                  16.heightBox,
                  _buildSearchArea(context, filter),
                ],
                20.heightBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TransactionTypeToggle(
                    isIncome: filter.isIncomeFilter,
                    onChanged: (val) => filter.setIsIncomeFilter(val),
                  ),
                ),
                20.heightBox,
                Expanded(
                  child: Consumer<UserSettingsProvider>(
                    builder: (context, settings, _) {
                      final filteredTransactions =
                          filter.filterTransactions(transaction.transactions);

                      if (filteredTransactions.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final tx = filteredTransactions[index];
                          return TransactionListItem(
                            transaction: tx,
                            currency: settings.selectedCurrency,
                            onDelete: () {
                              final originalIndex =
                                  transaction.transactions.indexOf(tx);
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
      ),
    );
  }

  Widget _buildSearchArea(BuildContext context, TransactionFilterProvider filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: 16,
        blur: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        gradientColors: [
          Colors.white.withValues(alpha: 0.12),
          AppColors.primaryColor.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.08),
        ],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _searchFocusNode,
                onChanged: (val) => filter.setSearchQuery(val),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Search transactions...",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            12.widthBox,
            Container(
              height: 40,
              width: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            IconButton(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryColor,
                        onPrimary: Colors.white,
                        surface: Color(0xFF1E2141),
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                filter.setDateRange(range);
              },
              icon: SvgPicture.asset(
                AppImages.calendar,
                colorFilter: ColorFilter.mode(
                  filter.selectedDateRange != null
                      ? AppColors.primaryColor
                      : Colors.white.withValues(alpha: 0.5),
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          16.heightBox,
          Text(
            "No transactions found",
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
