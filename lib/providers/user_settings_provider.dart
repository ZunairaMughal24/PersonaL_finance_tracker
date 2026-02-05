import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingsProvider extends ChangeNotifier {
  static const String _settingsBoxName = 'settings';
  static const String _currencyKey = 'selected_currency';

  late Box _box;
  String _selectedCurrency = 'USD';

  String get selectedCurrency => _selectedCurrency;

  UserSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_settingsBoxName);
    _selectedCurrency = _box.get(_currencyKey, defaultValue: 'USD');
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    await _box.put(_currencyKey, currency);
    notifyListeners();
  }

  static List<String> get availableCurrencies => [
    'USD',
    'EUR',
    'GBP',
    'PKR',
    'INR',
    'JPY',
  ];
}
