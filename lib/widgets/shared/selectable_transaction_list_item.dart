import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/widgets/transaction/transaction_list_item.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';

class SelectableTransactionListItem extends StatefulWidget {
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

  @override
  State<SelectableTransactionListItem> createState() =>
      _SelectableTransactionListItemState();
}

class _SelectableTransactionListItemState
    extends State<SelectableTransactionListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  static const double _kActionWidth = 70.0;
  static const double _kBorderRadius = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isSpecialMode => widget.isHistoryMode || widget.isArchiveMode;

  // Right swipe (start actions)
  double get _maxSlideRight => _kActionWidth;
  // Left swipe (end actions)
  double get _maxSlideLeft =>
      _isSpecialMode ? _kActionWidth : (_kActionWidth * 2);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.isSelectionMode) return;
    setState(() {
      _dragExtent += details.delta.dx;
      // Allow swiping in both directions
      _dragExtent = _dragExtent.clamp(-_maxSlideLeft - 20, _maxSlideRight + 20);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.isSelectionMode) return;

    if (_dragExtent > _maxSlideRight / 2) {
      _snapTo(1); // Snap to Right (reveal left side)
    } else if (_dragExtent < -_maxSlideLeft / 2) {
      _snapTo(-1); // Snap to Left (reveal right side)
    } else {
      _snapTo(0); // Snap to Center
    }
  }

  void _snapTo(int direction) {
    final double target = direction == 1
        ? _maxSlideRight
        : (direction == -1 ? -_maxSlideLeft : 0);

    final animation = Tween<double>(begin: _dragExtent, end: target).animate(
      CurvedAnimation(
        parent: _controller,
        curve: direction == 0 ? Curves.easeOutBack : Curves.elasticOut,
      ),
    );

    _runAnimation(animation);
  }

  void _runAnimation(Animation<double> animation) {
    _controller.reset();
    animation.addListener(() {
      setState(() => _dragExtent = animation.value);
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.transaction.id!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          // ── Background Actions Left (Start Pane) ──
          if (_dragExtent > 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      (widget.isArchiveMode
                              ? const Color(0xFF065F46) // teal
                              : widget.isHistoryMode
                              ? const Color(0xFF1E3A8A) // blue
                              : const Color(0xFF14532D)) // green
                          .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(_kBorderRadius),
                ),
                child: Row(
                  children: [
                    _ActionButton(
                      icon: widget.isArchiveMode
                          ? Icons.unarchive_rounded
                          : widget.isHistoryMode
                          ? Icons.settings_backup_restore_rounded
                          : Icons.edit_outlined,
                      label: widget.isArchiveMode
                          ? 'Unarchive'
                          : widget.isHistoryMode
                          ? 'Restore'
                          : 'Edit',
                      onTap: () {
                        _snapTo(0);
                        widget.onPrimaryAction(id);
                      },
                    ),
                  ],
                ),
              ),
            ),

          // ── Background Actions Right (End Pane) ──
          if (_dragExtent < 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(_kBorderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isSpecialMode)
                      _ActionButton(
                        icon: Icons.archive_rounded,
                        label: 'Archive',
                        onTap: () {
                          _snapTo(0);
                          widget.onArchive?.call(id);
                        },
                      ),
                    _ActionButton(
                      icon: _isSpecialMode
                          ? Icons.delete_forever_rounded
                          : Icons.delete_rounded,
                      label: 'Delete',
                      onTap: () {
                        _snapTo(0);
                        _showPermanentDeleteConfirm(context, id);
                      },
                    ),
                  ],
                ),
              ),
            ),

          // ── Foreground Sliding Card ──
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onTap: () {
              if (widget.isSelectionMode) {
                widget.onToggleSelection(id);
              } else if (_dragExtent != 0) {
                _snapTo(0);
              } else {
                widget.onPrimaryAction(id);
              }
            },
            onLongPress: () => widget.onToggleSelection(id),
            child: Transform.translate(
              offset: Offset(_dragExtent, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_kBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_kBorderRadius),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionListItem(
                          transaction: widget.transaction,
                          currency: widget.currency,
                          outerPadding: EdgeInsets.zero,
                          onDelete: () => _isSpecialMode
                              ? _showPermanentDeleteConfirm(context, id)
                              : widget.onDelete(id),
                          onEdit: () => widget.onPrimaryAction(id),
                          borderColor: widget.isSelected
                              ? AppColors.primaryColor.withValues(alpha: 0.6)
                              : widget.isSelectionMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : null,
                        ),
                      ),
                      if (widget.isSelectionMode) ...[
                        10.widthBox,
                        _SelectionIndicator(isSelected: widget.isSelected),
                        12.widthBox,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermanentDeleteConfirm(BuildContext context, int id) {
    TransactionModals.showSingleDeleteConfirm(
      context: context,
      onConfirm: () => widget.onDelete(id),
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
                    color: Colors.white.withValues(alpha: 0.15),
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
