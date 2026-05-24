import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';

class SelectableTransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isHistoryMode;
  final Function(int) onToggleSelection;
  final Function(int)
  onPrimaryAction; // Restore for history, Edit for activity?
  final Function(int)
  onDelete; // Delete permanently for history, Archive for activity

  const SelectableTransactionListItem({
    super.key,
    required this.transaction,
    required this.currency,
    required this.isSelected,
    required this.isSelectionMode,
    required this.isHistoryMode,
    required this.onToggleSelection,
    required this.onPrimaryAction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.key.toString() + (isHistoryMode ? "_hist" : "_act")),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onPrimaryAction(transaction.key as int);
        } else {
          onDelete(transaction.key as int);
        }
        return false;
      },
      child: GestureDetector(
        onLongPress: () => onToggleSelection(transaction.key as int),
        onTap: () {
          if (isSelectionMode) {
            onToggleSelection(transaction.key as int);
          } else {
            onPrimaryAction(transaction.key as int);
          }
        },
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
                  onDelete: () => onDelete(transaction.key as int),
                  onEdit: () => onPrimaryAction(transaction.key as int),
                  borderColor: isSelected
                      ? AppColors.primaryColor.withValues(alpha: 0.6)
                      : isSelectionMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : null,
                ),
              ),
              if (isSelectionMode) ...[
                10.widthBox,
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

  Widget _buildSwipeBackground(bool isPrimary) {
    final color = isPrimary ? Colors.green : Colors.red;
    final icon = isPrimary
        ? (isHistoryMode ? Icons.restore : Icons.edit_outlined)
        : (isHistoryMode ? Icons.delete_forever : Icons.archive_outlined);
    final label = isPrimary
        ? (isHistoryMode ? "Restore" : "Edit")
        : (isHistoryMode ? "Delete" : "Archive");

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: isPrimary ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
