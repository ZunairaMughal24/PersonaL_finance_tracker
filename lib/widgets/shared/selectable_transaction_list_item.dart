import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:montage/widgets/shared/fluid_swipe_action_container.dart';

class SelectableTransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final String currency;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isHistoryMode;
  final bool isArchiveMode;
  final Function(int) onToggleSelection;
  final Function(int) onPrimaryAction;
  final Function(int) onDelete;
  final Function(int)? onArchive;

  const SelectableTransactionListItem({
    super.key,
    required this.transaction,
    required this.currency,
    required this.isSelected,
    required this.isSelectionMode,
    required this.isHistoryMode,
    this.isArchiveMode = false,
    required this.onToggleSelection,
    required this.onPrimaryAction,
    required this.onDelete,
    this.onArchive,
  });

  bool get _isSpecialMode => isHistoryMode || isArchiveMode;
  static const double _kActionWidth = 70.0;
  static const double _kBorderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    final id = transaction.id!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: FluidSwipeActionContainer(
        key: ValueKey(
          '$id${isHistoryMode
              ? "_h"
              : isArchiveMode
              ? "_a"
              : "_act"}',
        ),
        isDisabled: isSelectionMode,
        borderRadius: _kBorderRadius,
        maxSlideRight: _kActionWidth,
        maxSlideLeft: _isSpecialMode ? _kActionWidth : (_kActionWidth * 2),

        // ── Right Swipe Background (Edit / Restore) ──
        rightSwipeBackground: Container(
          decoration: BoxDecoration(
            color:
                (isArchiveMode
                        ? const Color(0xFF065F46) // teal
                        : isHistoryMode
                        ? const Color(0xFF1E3A8A) // blue
                        : const Color(0xFF14532D)) // green
                    .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(_kBorderRadius),
          ),
          child: Row(
            children: [
              _ActionButton(
                icon: isArchiveMode
                    ? Icons.unarchive_rounded
                    : isHistoryMode
                    ? Icons.settings_backup_restore_rounded
                    : Icons.edit_outlined,
                label: isArchiveMode
                    ? 'Unarchive'
                    : isHistoryMode
                    ? 'Restore'
                    : 'Edit',
                onTap: () => onPrimaryAction(id),
              ),
            ],
          ),
        ),

        // ── Left Swipe Background (Delete / Archive) ──
        leftSwipeBackground: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(_kBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_isSpecialMode)
                _ActionButton(
                  icon: Icons.archive_rounded,
                  label: 'Archive',
                  onTap: () => onArchive?.call(id),
                ),
              _ActionButton(
                icon: _isSpecialMode
                    ? Icons.delete_forever_rounded
                    : Icons.delete_rounded,
                label: 'Delete',
                onTap: () => _showPermanentDeleteConfirm(context, id),
              ),
            ],
          ),
        ),

        // ── Main Content ──
        child: InkWell(
          onTap: () {
            if (isSelectionMode) {
              onToggleSelection(id);
            } else {
              onPrimaryAction(id);
            }
          },
          onLongPress: () => onToggleSelection(id),
          child: Row(
            children: [
              Expanded(
                child: TransactionListItem(
                  transaction: transaction,
                  currency: currency,
                  outerPadding: EdgeInsets.zero,
                  onDelete: () => _isSpecialMode
                      ? _showPermanentDeleteConfirm(context, id)
                      : onDelete(id),
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
                _SelectionIndicator(isSelected: isSelected),
                12.widthBox,
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPermanentDeleteConfirm(BuildContext context, int id) {
    TransactionModals.showSingleDeleteConfirm(
      context: context,
      onConfirm: () => onDelete(id),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  const _SelectionIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
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
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : null,
    );
  }
}
