import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/activity/activity_filter_chip.dart';
import 'package:montage/widgets/category_picker_bottom_sheet.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ActivityFilterRow extends StatelessWidget {
  final TransactionFilterProvider filter;
  final TransactionProvider transaction;

  const ActivityFilterRow({
    super.key,
    required this.filter,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ActivityFilterChip(
            label: "All",
            isSelected: filter.isIncomeFilter == null,
            onTap: () => filter.setIsIncomeFilter(null),
            icon: Icons.all_inclusive_rounded,
          ),
          8.widthBox,
          ActivityFilterChip(
            label: "Income",
            isSelected: filter.isIncomeFilter == true,
            onTap: () => filter.setIsIncomeFilter(true),
            icon: Icons.arrow_upward_rounded,
            activeColor: AppColors.green,
          ),
          8.widthBox,
          ActivityFilterChip(
            label: "Expense",
            isSelected: filter.isIncomeFilter == false,
            onTap: () => filter.setIsIncomeFilter(false),
            icon: Icons.arrow_downward_rounded,
            activeColor: AppColors.red,
          ),
          8.widthBox,
          ActivityFilterChip(
            label: filter.selectedCategory ?? "Category",
            isSelected:
                filter.selectedCategory != null &&
                filter.selectedCategory != 'All',
            onTap: () => _pickCategory(context),
            icon: Icons.category_outlined,
          ),
          16.widthBox,
          _ExportChip(filter: filter, transaction: transaction),
        ],
      ),
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final selected = await CategoryPickerBottomSheet.show(
      context: context,
      selectedCategory: filter.selectedCategory,
      isIncome: filter.isIncomeFilter,
    );
    if (selected != null) {
      filter.setCategory(selected);
    }
  }
}

class _ExportChip extends StatelessWidget {
  final TransactionFilterProvider filter;
  final TransactionProvider transaction;

  const _ExportChip({required this.filter, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final filtered = filter.filterTransactions(transaction.transactions);
        if (filtered.isEmpty) return;
        final settings = context.read<UserSettingsProvider>();
        ExportBottomSheet.show(
          context: context,
          transactions: filtered,
          userName: settings.userName,
          currency: settings.selectedCurrency,
        );
      },
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
}
