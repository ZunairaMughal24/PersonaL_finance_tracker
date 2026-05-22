import 'package:flutter/material.dart';
import 'package:montage/core/constants/app_colors.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/app_background.dart';
import 'package:montage/widgets/history/history_action_bar.dart';
import 'package:montage/widgets/history/history_list_item.dart';
import 'package:montage/widgets/premium_action_dialog.dart';
import 'package:provider/provider.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/widgets/glass_container.dart';
import 'package:montage/widgets/custom_app_bar.dart';
import 'package:montage/core/utils/toast_utility.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HistoryViewModel(context.read<TransactionProvider>()),
      child: const _HistoryScreenView(),
    );
  }
}

class _HistoryScreenView extends StatelessWidget {
  const _HistoryScreenView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    final settings = context.watch<UserSettingsProvider>();
    final archived = vm.archivedTransactions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: vm.isSelectionMode
            ? "${vm.selectedCount} Selected"
            : 'Transaction History',
        actions: [
          if (!vm.isSelectionMode && archived.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'restore_all') vm.restoreAll();
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'restore_all',
                  child: Text("Restore All"),
                ),
              ],
            ),
        ],
      ),
      body: AppBackground(
        style: BackgroundStyle.premiumHybrid,
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchArea(context, vm),
              20.heightBox,
              Expanded(
                child: archived.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
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
                            onDeletePermanently: (key) =>
                                _showDeleteConfirm(context, [key]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: vm.isSelectionMode
          ? HistoryActionBar(
              onRestore: vm.restoreSelected,
              onDelete: () =>
                  _showDeleteConfirm(context, vm.selectedKeys.toList()),
              onCancel: vm.clearSelection,
            )
          : null,
    );
  }

  Widget _buildSearchArea(BuildContext context, HistoryViewModel vm) {
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
        child: TextField(
          onChanged: vm.updateSearch,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: "Search history...",
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          16.heightBox,
          Text(
            "No archived transactions",
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, List<int> keys) {
    showDialog(
      context: context,
      builder: (context) => PremiumActionDialog(
        title: "Delete Permanently?",
        description:
            "You're about to delete ${keys.length} transactions forever. This action cannot be reversed.",
        confirmText: "Delete",
        confirmColor: Colors.redAccent,
        icon: Icons.delete_forever_rounded,
        onConfirm: () {
          // Future implementation: provider.deletePermanently(keys)
          ToastUtils.show(context, "Feature coming soon", isError: false);
        },
      ),
    );
  }
}
