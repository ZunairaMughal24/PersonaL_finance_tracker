import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  bool _notificationsEnabled = true;

  String get selectedCurrency => _selectedCurrency;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get profileImagePath => _profileImagePath;
  bool get notificationsEnabled => _notificationsEnabled;

  UserSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_settingsBoxName);
    _selectedCurrency = _box.get(_currencyKey, defaultValue: 'USD');
    _userName = _box.get(_nameKey, defaultValue: 'Zunaira Mughal');
    _userEmail = _box.get(_emailKey, defaultValue: 'zunaira@example.com');
    _profileImagePath = _box.get(_imageKey);
    _notificationsEnabled = _box.get(
      'notifications_enabled',
      defaultValue: true,
    );
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    await _box.put(_currencyKey, currency);
    notifyListeners();
  }

  Future<void> setUserName(String name) => updateUserName(name);
  Future<void> setProfileImage(String path) => updateProfileImage(path);
  Future<void> setUserEmail(String email) => updateUserEmail(email);

  Future<void> updateProfileImage(String path) async {
    _profileImagePath = path;
    await _box.put(_imageKey, path);
    notifyListeners();
  }

  Future<void> pickAndUpdateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await updateProfileImage(image.path);
    }
  }

  Future<void> updateUserName(String name) async {
    if (name.trim().isNotEmpty) {
      _userName = name.trim();
      await _box.put(_nameKey, _userName);
      notifyListeners();
    }
  }

  Future<void> updateUserEmail(String email) async {
    if (email.trim().isNotEmpty) {
      _userEmail = email.trim();
      await _box.put(_emailKey, _userEmail);
      notifyListeners();
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _box.put('notifications_enabled', enabled);
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
