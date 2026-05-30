import 'package:flutter/material.dart';
import 'package:montage/core/utils/currency_utils.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/core/enums/sync_status.dart';

class HomeViewModel extends ChangeNotifier {
  final TransactionProvider _txProvider;
  final UserSettingsProvider _settingsProvider;

  HomeViewModel(this._txProvider, this._settingsProvider) {
    _txProvider.addListener(notifyListeners);
    _settingsProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _txProvider.removeListener(notifyListeners);
    _settingsProvider.removeListener(notifyListeners);
    super.dispose();
  }

  // Readiness
  bool get isReady => _txProvider.isReady && _settingsProvider.isReady;

  // User info
  String get userName => _settingsProvider.userName;
  String? get profileImagePath => _settingsProvider.profileImagePath;

  // Balances (pre-formatted for the UI)
  double get totalBalance => _txProvider.totalBalance;
  bool get hasEntries => _txProvider.transactions.isNotEmpty;

  String get formattedIncome => CurrencyUtils.formatAmount(
    _txProvider.totalIncome,
    _settingsProvider.selectedCurrency,
  );

  String get formattedExpense => CurrencyUtils.formatAmount(
    _txProvider.totalExpense,
    _settingsProvider.selectedCurrency,
  );

  // AI Insights (pass-through from provider)
  Future<String?>? get insightsFuture => _txProvider.insightsFuture;
  String? get cachedInsights => _txProvider.cachedInsightsValue;

  SyncStatus get syncStatus => _txProvider.syncStatus;
}
