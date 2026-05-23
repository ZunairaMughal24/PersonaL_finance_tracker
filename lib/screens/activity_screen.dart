import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/config/router.dart';

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
                _buildSearchArea(context, filter),
              ],
              16.heightBox,
              _buildModernFilterRow(context, filter, transaction),
              16.heightBox,
              Expanded(
                child: Consumer<UserSettingsProvider>(
                  builder: (context, settings, _) {
                    final filteredTransactions = filter.filterTransactions(
                      transaction.transactions,
                    );

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

  Widget _buildSearchArea(
    BuildContext context,
    TransactionFilterProvider filter,
  ) {
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

  Widget _buildModernFilterRow(
    BuildContext context,
    TransactionFilterProvider filter,
    TransactionProvider transaction,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip(
            label: "All",
            isSelected: filter.isIncomeFilter == null,
            onTap: () => filter.setIsIncomeFilter(null),
            icon: Icons.all_inclusive_rounded,
          ),
          8.widthBox,
          _buildChip(
            label: "Income",
            isSelected: filter.isIncomeFilter == true,
            onTap: () => filter.setIsIncomeFilter(true),
            icon: Icons.arrow_upward_rounded,
            activeColor: AppColors.green,
          ),
          8.widthBox,
          _buildChip(
            label: "Expense",
            isSelected: filter.isIncomeFilter == false,
            onTap: () => filter.setIsIncomeFilter(false),
            icon: Icons.arrow_downward_rounded,
            activeColor: AppColors.red,
          ),
          8.widthBox,
          _buildChip(
            label: filter.selectedCategory ?? "Category",
            isSelected:
                filter.selectedCategory != null &&
                filter.selectedCategory != 'All',
            onTap: () => _showCategoryPicker(context, filter),
            icon: Icons.category_outlined,
          ),
          16.widthBox,
          _buildExportAction(context, filter, transaction),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        gradientColors: isSelected
            ? [
                (activeColor ?? AppColors.primaryColor).withValues(alpha: 0.3),
                (activeColor ?? AppColors.primaryColor).withValues(alpha: 0.1),
              ]
            : [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
        borderColor: isSelected
            ? (activeColor ?? AppColors.primaryColor).withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.05),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? (activeColor ?? Colors.white)
                  : Colors.white70,
            ),
            8.widthBox,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportAction(
    BuildContext context,
    TransactionFilterProvider filter,
    TransactionProvider transaction,
  ) {
    return GestureDetector(
      onTap: () {
        final filteredTransactions = filter.filterTransactions(
          transaction.transactions,
        );
        if (filteredTransactions.isEmpty) return;

        final settings = context.read<UserSettingsProvider>();
        ExportBottomSheet.show(
          context: context,
          transactions: filteredTransactions,
          userName: settings.userName,
          currency: settings.selectedCurrency,
        );
      },
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        gradientColors: [
          AppColors.primaryColor.withValues(alpha: 0.6),
          AppColors.primaryColor.withValues(alpha: 0.4),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ios_share_rounded, size: 16, color: Colors.white),
            8.widthBox,
            const Text(
              "Export",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCategoryPicker(
    BuildContext context,
    TransactionFilterProvider filter,
  ) async {
    final categories = [
      'All',
      'Food',
      'Transport',
      'Shopping',
      'Rent',
      'Health',
      'Salary',
      'Others',
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Category",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            16.heightBox,
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    categories[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context, categories[index]),
                  trailing: filter.selectedCategory == categories[index]
                      ? const Icon(Icons.check, color: AppColors.primaryColor)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      filter.setCategory(selected == 'All' ? null : selected);
    }
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
