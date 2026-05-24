import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/shared/transaction_modals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:provider/provider.dart';

class TransactionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;
  final VoidCallback? onShowBatchActions;
  final String title;

  const TransactionAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onToggleSearch,
    required this.title,
    this.onShowBatchActions,
  });

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback? onPressed,
    Color color = Colors.white70,
    String? tooltip,
    double size = 22,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      tooltip: tooltip,
      splashRadius: 20,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionListViewModel>();
    final transactions = vm.filteredTransactions;

    return AppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        vm.isSelectionMode ? '${vm.selectedCount} Selected' : title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          fontSize: 21,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (vm.isSelectionMode) ...[
          if (vm.selectedCount > 0)
            _iconBtn(
              icon: Icons.bolt_rounded,
              color: AppColors.primaryLight,
              tooltip: 'Batch Actions',
              onPressed: onShowBatchActions,
            ),
          _iconBtn(
            icon: vm.selectedCount == transactions.length
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            color: vm.selectedCount == transactions.length
                ? AppColors.primaryLight
                : Colors.white70,
            tooltip: vm.selectedCount == transactions.length
                ? 'Deselect All'
                : 'Select All',
            onPressed: () => vm.selectedCount == transactions.length
                ? vm.deselectAll()
                : vm.selectAll(),
          ),
          const SizedBox(width: 4),
        ] else ...[
          _iconBtn(
            icon: isSearchVisible
                ? Icons.search_off_rounded
                : Icons.search_rounded,
            color: isSearchVisible ? AppColors.primaryLight : Colors.white70,
            tooltip: isSearchVisible ? 'Close Search' : 'Search',
            onPressed: onToggleSearch,
          ),
          if (transactions.isNotEmpty)
            _AppBarPopupMenu(transactions: transactions, vm: vm),
          const SizedBox(width: 4),
        ],
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.10),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}

class _AppBarPopupMenu extends StatelessWidget {
  final List transactions;
  final TransactionListViewModel vm;

  const _AppBarPopupMenu({required this.transactions, required this.vm});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'More options',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.10), width: 1),
      ),
      color: const Color(0xFF1E2444),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.more_vert_rounded, color: Colors.white70, size: 22),
      ),
      onSelected: (val) {
        if (val == 'select' && transactions.isNotEmpty) {
          vm.enterSelectionMode();
        } else if (val == 'clear_filters') {
          vm.updateSearch("");
          vm.setCategory(null);
          vm.setIsIncomeFilter(null);
        } else if (val == 'restore_all' || val == 'clear_dashboard') {
          if (vm.isHistoryMode) {
            TransactionModals.showRestoreAllConfirm(context: context, vm: vm);
          } else {
            TransactionModals.showArchiveAllConfirm(context: context, vm: vm);
          }
        }
      },
      itemBuilder: (context) => [
        if (transactions.isNotEmpty)
          _buildMenuItem(
            value: 'select',
            icon: Icons.check_circle_outline_rounded,
            label: 'Select Items',
            iconColor: AppColors.primaryLight,
            bgColor: AppColors.primaryColor.withValues(alpha: 0.15),
          ),
        if (vm.searchQuery.isNotEmpty || vm.selectedCategory != null)
          _buildMenuItem(
            value: 'clear_filters',
            icon: Icons.filter_alt_off_rounded,
            label: 'Clear Filters',
            iconColor: Colors.amberAccent,
            bgColor: Colors.amberAccent.withValues(alpha: 0.1),
          ),
        if (transactions.isNotEmpty)
          _buildMenuItem(
            value: vm.isHistoryMode ? 'restore_all' : 'clear_dashboard',
            icon: vm.isHistoryMode
                ? Icons.settings_backup_restore_rounded
                : null,
            svgAsset: vm.isHistoryMode ? null : AppImages.trashBin,
            label: vm.isHistoryMode ? 'Restore All' : 'Delete All',
            iconColor: vm.isHistoryMode ? AppColors.accent : AppColors.red,
            bgColor: (vm.isHistoryMode ? AppColors.accent : AppColors.red)
                .withValues(alpha: 0.15),
          ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    IconData? icon,
    String? svgAsset,
    required String label,
    required Color iconColor,
    required Color bgColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      height: 16,
                    )
                  : Icon(icon, size: 18, color: iconColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
