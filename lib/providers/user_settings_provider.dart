import 'package:flutter/material.dart';
import 'package:montage/core/interfaces/i_user_settings_repository.dart';
import 'package:montage/core/constants/app_keys.dart';

class UserSettingsProvider extends ChangeNotifier {
  late IUserSettingsRepository _repository;
  String? _userId;
  String _selectedCurrency = 'USD';
  String _userName = 'User';
  String _userEmail = '';
  String? _profileImagePath;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _isReady = false;

  String get selectedCurrency => _selectedCurrency;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get profileImagePath => _profileImagePath;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get isReady => _isReady;

  UserSettingsProvider({IUserSettingsRepository? repository}) {
    if (repository != null) {
      _repository = repository;
    }
  }

  void updateRepository(IUserSettingsRepository repository) {
    _repository = repository;
  }

  Future<void> updateUser(
    String? userId, {
    String? displayName,
    String? email,
  }) async {
    if (userId == _userId) {
      if (_userName == 'User' &&
          displayName != null &&
          displayName.isNotEmpty) {
        _userName = displayName;
        notifyListeners();
      }
      return;
    }

    _userId = userId;
    _isReady = false;

    if (userId != null) {
      if (displayName != null) _userName = displayName;
      if (email != null) _userEmail = email;

      await _repository.init(userId);
      await _loadSettings(displayName: displayName, email: email);
      _isReady = true;
      notifyListeners();
    } else {
      _reset();
    }
  }

  void _reset() {
    _userName = 'User';
    _userEmail = 'user@example.com';
    _profileImagePath = null;
    _notificationsEnabled = true;
    _biometricEnabled = false;
    _selectedCurrency = 'USD';
    _isReady = true;
    notifyListeners();
  }

  Future<void> _loadSettings({String? displayName, String? email}) async {
    if (_repository.isEmpty) {
      final cloud = await _repository.pullFromCloud();
      if (cloud != null) {
        for (var e in cloud.entries) {
          await _repository.put(e.key, e.value);
        }
      }
    }
    _applyLocalSettings(displayName, email);
  }

  void _applyLocalSettings(String? displayName, String? email) {
    _userName = _repository.get(AppKeys.userName) ?? displayName ?? 'User';
    _userEmail =
        _repository.get(AppKeys.userEmail) ?? email ?? 'user@example.com';
    _profileImagePath = _repository.get(AppKeys.profileImage);
    _notificationsEnabled = _repository.get<bool>(
      AppKeys.notificationsEnabled,
      defaultValue: true,
    )!;
    _biometricEnabled = _repository.get<bool>(
      AppKeys.biometricEnabled,
      defaultValue: false,
    )!;
    _selectedCurrency = _repository.get<String>(
      AppKeys.currency,
      defaultValue: 'USD',
    )!;

    if (displayName != null) _repository.put(AppKeys.userName, displayName);
    if (email != null) _repository.put(AppKeys.userEmail, email);
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    await _repository.put(AppKeys.currency, currency);
    _pushToCloud();
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    _userName = name.trim();
    await _repository.put(AppKeys.userName, _userName);
    _pushToCloud();
    notifyListeners();
  }

  Future<void> updateUserEmail(String email) async {
    _userEmail = email.trim();
    await _repository.put(AppKeys.userEmail, _userEmail);
    _pushToCloud();
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _repository.put(AppKeys.notificationsEnabled, enabled);
    _pushToCloud();
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    await _repository.put(AppKeys.biometricEnabled, enabled);
    _pushToCloud();
    notifyListeners();
  }

  Future<void> updateProfileImage(String? path) async {
    _profileImagePath = path;
    if (path == null) {
      await _repository.delete(AppKeys.profileImage);
    } else {
      await _repository.put(AppKeys.profileImage, path);
    }
    notifyListeners();
  }

  void _pushToCloud() {
    _repository.pushToCloud({
      AppKeys.currency: _selectedCurrency,
      AppKeys.userName: _userName,
      AppKeys.userEmail: _userEmail,
      AppKeys.biometricEnabled: _biometricEnabled,
      AppKeys.notificationsEnabled: _notificationsEnabled,
    });
  }

  Future<void> setUserName(String name) => updateUserName(name);
  Future<void> setProfileImage(String path) => updateProfileImage(path);
  Future<void> setUserEmail(String email) => updateUserEmail(email);
  Future<void> removeProfileImage() => updateProfileImage(null);

  static List<String> get availableCurrencies => [
    'USD',
    'EUR',
    'GBP',
    'PKR',
    'INR',
    'JPY',
  ];
}
