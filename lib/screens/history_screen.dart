import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:montage/core/constants/app_images.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/history/history_action_bar.dart';
import 'package:montage/widgets/history/history_list_item.dart';
import 'package:montage/widgets/history/history_modals.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:montage/core/utils/toast_utility.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HistoryViewModel(context.read<TransactionProvider>()),
      child: Consumer<HistoryViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: _HistoryAppBar(
              isSearchVisible: _isSearchVisible,
              onToggleSearch: () => setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (_isSearchVisible) {
                  _searchFocusNode.requestFocus();
                } else {
                  vm.updateSearch('');
                  _searchFocusNode.unfocus();
                }
              }),
            ),
            body: AppBackground(
              style: BackgroundStyle.premiumHybrid,
              child: SafeArea(
                child: Column(
                  children: [
                    if (_isSearchVisible) ...[
                      16.heightBox,
                      _HistorySearchArea(
                        focusNode: _searchFocusNode,
                        onChanged: vm.updateSearch,
                      ),
                    ],
                    20.heightBox,
                    Expanded(child: _HistoryList(vm: vm)),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: vm.isSelectionMode
                ? HistoryActionBar(
                    onRestore: () async {
                      await vm.restoreSelected();
                      if (context.mounted) {
                        ToastUtils.show(
                          context,
                          "Selected transactions restored",
                        );
                      }
                    },
                    onDelete: () => HistoryModals.showDeleteConfirm(
                      context: context,
                      vm: vm,
                      keys: vm.selectedKeys.toList(),
                    ),
                    onCancel: vm.clearSelection,
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;

  const _HistoryAppBar({
    required this.isSearchVisible,
    required this.onToggleSearch,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    final archived = vm.archivedTransactions;

    return CustomAppBar(
      title: vm.isSelectionMode
          ? "${vm.selectedCount} Selected"
          : 'Transaction History',
      centerTitle: false,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!vm.isSelectionMode)
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                onPressed: onToggleSearch,
                icon: Icon(
                  isSearchVisible ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
              ),
            if (vm.isSelectionMode)
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: Icon(
                  vm.selectedCount == archived.length
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () => vm.selectedCount == archived.length
                    ? vm.deselectAll()
                    : vm.selectAll(),
              ),
            if (!vm.isSelectionMode && archived.isNotEmpty)
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                onSelected: (val) {
                  if (val == 'restore_all') {
                    HistoryModals.showRestoreAllConfirm(
                      context: context,
                      vm: vm,
                    );
                  } else if (val == 'select') {
                    vm.enterSelectionMode();
                  }
                },
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => [
                  _buildMenuItem(
                    'select',
                    Icons.check_circle_outline_rounded,
                    "Select Items",
                  ),
                  _buildMenuItem(
                    'restore_all',
                    Icons.settings_backup_restore_rounded,
                    "Restore All",
                  ),
                ],
              ),
            8.widthBox,
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HistorySearchArea extends StatelessWidget {
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _HistorySearchArea({required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        borderRadius: 16,
        blur: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        gradientColors: [
          Colors.white.withValues(alpha: 0.12),
          AppColors.primaryColor.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.08),
        ],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                onChanged: onChanged,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Search history...",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            12.widthBox,
            Container(
              height: 40,
              width: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            IconButton(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryColor,
                        onPrimary: Colors.white,
                        surface: Color(0xFF1E2141),
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                vm.setDateRange(range);
              },
              icon: SvgPicture.asset(
                AppImages.calendar,
                colorFilter: ColorFilter.mode(
                  vm.selectedDateRange != null
                      ? AppColors.primaryColor
                      : Colors.white.withValues(alpha: 0.5),
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final HistoryViewModel vm;

  const _HistoryList({required this.vm});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<UserSettingsProvider>();
    final archived = vm.archivedTransactions;

    if (archived.isEmpty) {
      return _HistoryEmptyState(isSearching: vm.searchQuery.isNotEmpty);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: archived.length,
      itemBuilder: (context, index) {
        final tx = archived[index];
        return HistoryListItem(
          transaction: tx,
          currency: settings.selectedCurrency,
          isSelected: vm.selectedKeys.contains(tx.key),
          isSelectionMode: vm.isSelectionMode,
          onToggleSelection: vm.toggleSelection,
          onRestore: (key) {
            vm.restoreSingle(key);
            ToastUtils.show(context, "Transaction restored");
          },
          onDeletePermanently: (key) => HistoryModals.showDeleteConfirm(
            context: context,
            vm: vm,
            keys: [key],
          ),
        );
      },
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  final bool isSearching;

  const _HistoryEmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.history_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          16.heightBox,
          Text(
            isSearching
                ? "No transactions match your search"
                : "No archived transactions",
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
