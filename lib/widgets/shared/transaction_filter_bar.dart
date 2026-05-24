import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/widgets/shared/transaction_filter_chip.dart';
import 'package:montage/widgets/category_picker_bottom_sheet.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/history/export_bottom_sheet.dart';
import 'package:provider/provider.dart';

/// A shared, dumb filter row used by both Activity and History screens.
/// Knows nothing about providers or view models, just values and callbacks.
class TransactionFilterBar extends StatelessWidget {
  final bool? isIncomeFilter;
  final String? selectedCategory;
  final void Function(bool?) onTypeChanged;
  final void Function(String?) onCategoryChanged;
  final List<TransactionModel> transactionsForExport;

  const TransactionFilterBar({
    super.key,
    required this.isIncomeFilter,
    required this.selectedCategory,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.transactionsForExport,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TransactionFilterChip(
            label: "All",
            isSelected: isIncomeFilter == null,
            onTap: () => onTypeChanged(null),
            icon: Icons.all_inclusive_rounded,
          ),
          8.widthBox,
          TransactionFilterChip(
            label: "Income",
            isSelected: isIncomeFilter == true,
            onTap: () => onTypeChanged(true),
            icon: Icons.arrow_upward_rounded,
            activeColor: AppColors.green,
          ),
          8.widthBox,
          TransactionFilterChip(
            label: "Expense",
            isSelected: isIncomeFilter == false,
            onTap: () => onTypeChanged(false),
            icon: Icons.arrow_downward_rounded,
            activeColor: AppColors.red,
          ),
          8.widthBox,
          TransactionFilterChip(
            label: selectedCategory ?? "Category",
            isSelected: selectedCategory != null,
            onTap: selectedCategory != null
                ? () => onCategoryChanged(null)
                : () async {
                    final selected = await CategoryPickerBottomSheet.show(
                      context: context,
                      selectedCategory: selectedCategory,
                      isIncome: isIncomeFilter,
                    );
                    if (selected != null) onCategoryChanged(selected);
                  },
            icon: selectedCategory != null
                ? Icons.close_rounded
                : Icons.category_outlined,
          ),
          16.widthBox,
          _ExportChip(transactions: transactionsForExport),
        ],
      ),
    );
  }
}

class _ExportChip extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _ExportChip({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (transactions.isEmpty) return;
        final settings = context.read<UserSettingsProvider>();
        ExportBottomSheet.show(
          context: context,
          transactions: transactions,
          userName: settings.userName,
          currency: settings.selectedCurrency,
        );
      },
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        gradientColors: [
          AppColors.primaryColor.withValues(alpha: 0.6),
          AppColors.primaryColor.withValues(alpha: 0.4),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ios_share_rounded, size: 18, color: Colors.white),
            10.widthBox,
            const Text(
              "Export",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
