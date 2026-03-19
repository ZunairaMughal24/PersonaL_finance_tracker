import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingsProvider extends ChangeNotifier {
  static const String _settingsBoxBaseName = 'settings';
  static const String _currencyKey = 'selected_currency';
  static const String _nameKey = 'user_name';
  static const String _imageKey = 'profile_image_path';
  static const String _emailKey = 'user_email';

  Box? _box;
  String? _userId;
  String _selectedCurrency = 'USD';
  String _userName = 'User';
  String _userEmail = '';
  String? _profileImagePath;
  bool _notificationsEnabled = true;

  String get selectedCurrency => _selectedCurrency;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get profileImagePath => _profileImagePath;
  bool get notificationsEnabled => _notificationsEnabled;

  UserSettingsProvider();

  Future<void> updateUser(String? userId) async {
    if (_userId == userId) return;
    
    _userId = userId;
    if (userId == null) {
      _userName = 'User';
      _userEmail = '';
      _profileImagePath = null;
      _box = null;
      notifyListeners();
      return;
    }

    _box = await Hive.openBox('${_settingsBoxBaseName}_$userId');
    _loadSettings();
  }

  void _loadSettings() {
    if (_box == null) return;
    _selectedCurrency = _box!.get(_currencyKey, defaultValue: 'USD');
    _userName = _box!.get(_nameKey, defaultValue: 'User');
    _userEmail = _box!.get(_emailKey, defaultValue: 'user@example.com');
    _profileImagePath = _box!.get(_imageKey);
    _notificationsEnabled = _box!.get(
      'notifications_enabled',
      defaultValue: true,
    );
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    if (_box != null) {
      await _box!.put(_currencyKey, currency);
    }
    notifyListeners();
  }

  Future<void> setUserName(String name) => updateUserName(name);
  Future<void> setProfileImage(String path) => updateProfileImage(path);
  Future<void> setUserEmail(String email) => updateUserEmail(email);

  Future<void> updateProfileImage(String? path) async {
    _profileImagePath = path;
    if (_box != null) {
      if (path == null) {
        await _box!.delete(_imageKey);
      } else {
        await _box!.put(_imageKey, path);
      }
    }
    notifyListeners();
  }

  Future<void> removeProfileImage() async {
    await updateProfileImage(null);
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
      if (_box != null) {
        await _box!.put(_nameKey, _userName);
      }
      notifyListeners();
    }
  }

  Future<void> updateUserEmail(String email) async {
    if (email.trim().isNotEmpty) {
      _userEmail = email.trim();
      if (_box != null) {
        await _box!.put(_emailKey, _userEmail);
      }
      notifyListeners();
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    if (_box != null) {
      await _box!.put('notifications_enabled', enabled);
    }
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
