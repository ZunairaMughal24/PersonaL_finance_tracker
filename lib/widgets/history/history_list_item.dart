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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              TransactionListItem(
                transaction: transaction,
                currency: currency,
                onDelete: () => onDeletePermanently(transaction.key as int),
                onEdit: () =>
                    onRestore(transaction.key as int), // Acts as single restore
              ),
              // Single Restore Overlay Button (Full Control)
              if (!isSelectionMode)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: () => onRestore(transaction.key as int),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings_backup_restore_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
