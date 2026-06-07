import 'package:flutter/material.dart';
import 'package:montage/widgets/app_bottom_sheet.dart';
import 'package:montage/widgets/app_button.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';
import 'package:montage/core/themes/text_theme_extension.dart';

class TransactionModals {
  // Single-item soft-delete — swipe action on activity/home moves item to History.
  static void showMoveToHistoryConfirm({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    const color = Color(0xFF6C63FF);
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded, color: color, size: 32),
          ),
          20.heightBox,
          const Text(
            "Move to History?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          const Text(
            "This transaction will be moved to History. You can restore it anytime.",
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
                  text: "Move",
                  color: color,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Single-item permanent delete — used from history/archive swipe actions.
  static void showSingleDeleteConfirm({
    required BuildContext context,
    required VoidCallback onConfirm,
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
            child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 32),
          ),
          20.heightBox,
          const Text(
            "Delete Permanently?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          const Text(
            "This cannot be undone.",
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
                  text: "Delete Forever",
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Batch permanent delete — shown from selection mode action bar.
  static void showDeleteConfirm({
    required BuildContext context,
    required int count,
    required VoidCallback onConfirm,
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
            child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 32),
          ),
          20.heightBox,
          const Text(
            "Delete Permanently?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          Text(
            "You're about to delete $count transaction${count > 1 ? 's' : ''} forever. This cannot be undone.",
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
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
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
    required VoidCallback onConfirm,
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
          const Text(
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
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
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
    required VoidCallback onConfirm,
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
            child: const Icon(Icons.delete_sweep_rounded, color: Colors.orangeAccent, size: 32),
          ),
          20.heightBox,
          const Text(
            "Delete All Transactions?",
            textAlign: TextAlign.center,
          ).titleLarge(color: Colors.white, weight: FontWeight.bold),
          12.heightBox,
          const Text(
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
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
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
