import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
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
        onTap: () => onToggleSelection(transaction.key as int),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: TransactionListItem(
                  transaction: transaction,
                  currency: currency,
                  onDelete: () => onDeletePermanently(transaction.key as int),
                  onEdit: () => onRestore(transaction.key as int),
                  borderColor: isSelected
                      ? AppColors.primaryColor.withValues(alpha: 0.6)
                      : isSelectionMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : null,
                ),
              ),
              if (isSelectionMode) ...[
                10.widthBox, // Tighten gap to tile
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                2.widthBox,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isRestore) {
    return Container(
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
