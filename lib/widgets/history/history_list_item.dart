import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';

class HistoryListItem extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(int) onToggleSelection;
  final Function(int) onRestore;
  final Function(int) onDeletePermanently;

  const HistoryListItem({
    super.key,
    required this.transaction,
    required this.currency,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDeletePermanently,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.key.toString()),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onRestore(transaction.key as int);
        } else {
          onDeletePermanently(transaction.key as int);
        }
        return false;
      },
      child: GestureDetector(
        onLongPress: () => onToggleSelection(transaction.key as int),
        onTap: () =>
            onToggleSelection(transaction.key as int), // Selective control
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                TransactionListItem(
                  transaction: transaction,
                  currency: currency,
                  onDelete: () => onDeletePermanently(transaction.key as int),
                  onEdit: () => onRestore(transaction.key as int),
                  borderColor: isSelectionMode
                      ? AppColors.primaryColor.withValues(alpha: 0.6)
                      : null,
                ),

                if (isSelectionMode) ...[
                  // Dark overlay to make tick icon pop
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.03),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.check_circle_outline_rounded,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.primaryColor.withValues(alpha: 0.8),
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isRestore) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRestore
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: isRestore ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isRestore ? Icons.restore : Icons.delete_forever,
            color: isRestore ? Colors.green : Colors.red,
          ),
          Text(
            isRestore ? "Restore" : "Delete",
            style: TextStyle(
              color: isRestore ? Colors.green : Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
