import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingsProvider extends ChangeNotifier {
  static const String _settingsBoxName = 'settings';
  static const String _currencyKey = 'selected_currency';
  static const String _nameKey = 'user_name';
  static const String _imageKey = 'profile_image_path';
  static const String _emailKey = 'user_email';

  late Box _box;
  String _selectedCurrency = 'USD';
  String _userName = 'Zunaira Mughal';
  String _userEmail = 'zunaira@example.com';
  String? _profileImagePath;

  String get selectedCurrency => _selectedCurrency;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get profileImagePath => _profileImagePath;

  UserSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_settingsBoxName);
    _selectedCurrency = _box.get(_currencyKey, defaultValue: 'USD');
    _userName = _box.get(_nameKey, defaultValue: 'Zunaira Mughal');
    _userEmail = _box.get(_emailKey, defaultValue: 'zunaira@example.com');
    _profileImagePath = _box.get(_imageKey);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    await _box.put(_currencyKey, currency);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    await _box.put(_nameKey, name);
    notifyListeners();
  }

  Future<void> setProfileImage(String path) async {
    _profileImagePath = path;
    await _box.put(_imageKey, path);
    notifyListeners();
  }

  Future<void> setUserEmail(String email) async {
    _userEmail = email;
    await _box.put(_emailKey, email);
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
