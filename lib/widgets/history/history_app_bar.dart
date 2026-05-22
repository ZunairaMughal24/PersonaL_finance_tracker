import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/history/history_modals.dart';
import 'package:provider/provider.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;

  const HistoryAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onToggleSearch,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    final archived = vm.archivedTransactions;

    return AppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        vm.isSelectionMode
            ? '${vm.selectedCount} Selected'
            : 'Transaction History',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          fontSize: 19,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (vm.isSelectionMode)
          IconButton(
            icon: Icon(
              vm.selectedCount == archived.length
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () => vm.selectedCount == archived.length
                ? vm.deselectAll()
                : vm.selectAll(),
          )
        else
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            offset: const Offset(0, 48),
            onSelected: (val) {
              if (val == 'search') {
                onToggleSearch();
              } else if (val == 'select' && archived.isNotEmpty) {
                vm.enterSelectionMode();
              } else if (val == 'restore_all') {
                HistoryModals.showRestoreAllConfirm(context: context, vm: vm);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(
                      isSearchVisible
                          ? Icons.search_off_rounded
                          : Icons.search_rounded,
                      size: 20,
                      color: isSearchVisible
                          ? AppColors.primaryColor
                          : Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    Text(isSearchVisible ? 'Close Search' : 'Search'),
                  ],
                ),
              ),
              if (archived.isNotEmpty)
                PopupMenuItem(
                  value: 'select',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      const Text('Select Items'),
                    ],
                  ),
                ),
              if (archived.isNotEmpty)
                PopupMenuItem(
                  value: 'restore_all',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings_backup_restore_rounded,
                        size: 20,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      const Text('Restore All'),
                    ],
                  ),
                ),
            ],
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.12),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
