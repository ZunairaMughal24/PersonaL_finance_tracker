import 'package:flutter/material.dart';
import 'package:montage/viewmodels/history_view_model.dart';
import 'package:montage/widgets/app_confirm_dialog.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class HistoryModals {
  static void showDeleteConfirm({
    required BuildContext context,
    required HistoryViewModel vm,
    required List<int> keys,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: "Delete Permanently?",
        description:
            "You're about to delete ${keys.length} transactions forever. This cannot be undone.",
        confirmText: "Delete Forever",
        confirmColor: Colors.redAccent,
        icon: Icons.delete_forever_rounded,
        onConfirm: () async {
          if (keys.length == vm.selectedCount) {
            await vm.deleteSelected();
          } else {
            await context.read<TransactionProvider>().deletePermanently(keys);
            vm.clearSelection();
          }
          if (context.mounted) {
            ToastUtils.show(
              context,
              "${keys.length} transactions deleted permanently",
            );
          }
        },
      ),
    );
  }

  static void showRestoreAllConfirm({
    required BuildContext context,
    required HistoryViewModel vm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: "Restore Everything?",
        description:
            "Do you want to restore all ${vm.archivedTransactions.length} archived transactions?",
        confirmText: "Restore All",
        icon: Icons.settings_backup_restore_rounded,
        onConfirm: () async {
          await vm.restoreAll();
          if (context.mounted) {
            ToastUtils.show(context, "All transactions restored");
          }
        },
      ),
    );
  }
}
