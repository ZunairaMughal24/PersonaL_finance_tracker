import 'package:flutter/material.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/core/utils/toast_utility.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/themes/text_theme_extension.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionModals {
  static void showDeleteConfirm({
    required BuildContext context,
    required TransactionListViewModel vm,
    required List<int> keys,
  }) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.redAccent,
              size: 32,
            ),
          ),
          20.heightBox,
          const Text(
            "Delete Permanently?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          Text(
            "You're about to delete ${keys.length} transactions forever. This cannot be undone.",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Cancel",
                  color: Colors.transparent,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              16.widthBox,
              Expanded(
                child: AppButton(
                  text: "Delete",
                  color: Colors.redAccent,
                  onPressed: () async {
                    Navigator.pop(context);
                    if (keys.length == vm.selectedCount) {
                      await vm.deleteSelected();
                    } else {
                      await context
                          .read<TransactionProvider>()
                          .deletePermanently(keys);
                      vm.clearSelection();
                    }
                    if (context.mounted) {
                      ToastUtils.show(
                        context,
                        "${keys.length} transaction${keys.length > 1 ? 's' : ''} deleted permanently",
                        isError: true,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void showRestoreAllConfirm({
    required BuildContext context,
    required TransactionListViewModel vm,
  }) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_backup_restore_rounded,
              color: Colors.blueAccent,
              size: 32,
            ),
          ),
          20.heightBox,
          const Text(
            "Restore Everything?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          Text(
            "Do you want to restore all items?",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Wait, No",
                  color: Colors.transparent,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              16.widthBox,
              Expanded(
                child: AppButton(
                  text: "Restore All",
                  color: Colors.blueAccent,
                  onPressed: () async {
                    Navigator.pop(context);
                    await vm.restoreAll();
                    if (context.mounted) {
                      ToastUtils.show(
                        context,
                        "All transactions restored successfully",
                        isError: false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void showArchiveAllConfirm({
    required BuildContext context,
    required TransactionListViewModel vm,
  }) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_sweep_rounded,
              color: Colors.orangeAccent,
              size: 32,
            ),
          ),
          20.heightBox,
          const Text(
            "Delete All Transactions?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          Text(
            "This will move all current transactions to history. You can restore them anytime.",
            textAlign: TextAlign.center,
          ).bodyLarge(color: Colors.white.withValues(alpha: 0.7)),
          32.heightBox,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Cancel",
                  color: Colors.transparent,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              16.widthBox,
              Expanded(
                child: AppButton(
                  text: "Delete All",
                  color: Colors.orangeAccent,
                  onPressed: () async {
                    Navigator.pop(context);
                    // Select all first to use archiveSelected
                    vm.selectAll();
                    await vm.archiveSelected();
                    if (context.mounted) {
                      ToastUtils.show(
                        context,
                        "All transactions moved to history",
                        isError: false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
