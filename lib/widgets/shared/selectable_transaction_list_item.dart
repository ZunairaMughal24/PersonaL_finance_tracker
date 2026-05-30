import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';

class SelectableTransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final String currency;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isHistoryMode;
  final Function(int) onToggleSelection;
  final Function(int) onPrimaryAction;
  final Function(int) onDelete;

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
    final id = transaction.id!;
    return Dismissible(
      key: Key('$id${isHistoryMode ? "_hist" : "_act"}'),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onPrimaryAction(id);
        } else {
          onDelete(id);
        }
        return false;
      },
      child: GestureDetector(
        onLongPress: () => onToggleSelection(id),
        onTap: () {
          if (isSelectionMode) {
            onToggleSelection(id);
          } else {
            onPrimaryAction(id);
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
                  onDelete: () => onDelete(id),
                  onEdit: () => onPrimaryAction(id),
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
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
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
        : null;
    final label = isPrimary
        ? (isHistoryMode ? "Restore" : "Edit")
        : (isHistoryMode ? "Delete" : "Delete");

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: isPrimary ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPrimary || icon != null)
            Icon(icon, color: color, size: 22)
          else
            SvgPicture.asset(
              AppImages.trashBin,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              height: 22,
            ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
