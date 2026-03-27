import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montage/services/firestore_sync_service.dart';

class UserSettingsProvider extends ChangeNotifier {
  static const String _currencyKey = 'selected_currency';
  static const String _nameKey = 'user_name';
  static const String _imageKey = 'profile_image_path';
  static const String _emailKey = 'user_email';
  static const String _biometricKey = 'biometric_enabled';

  Box? _box;
  String? _userId;
  final FirestoreSyncService _syncService = FirestoreSyncService();
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

  UserSettingsProvider();

  Future<void> updateUser(
    String? userId, {
    String? displayName,
    String? email,
  }) async {
    if (userId == _userId) {
      if (_box != null &&
          (_userName == 'User' || _userEmail == 'user@example.com')) {
        await _loadSettings(displayName: displayName, email: email);
      }
      return;
    }

    _userId = userId;
    _isReady = false;
    if (_box != null) {
      await _box!.close();
      _box = null;
    }

    if (userId != null) {
      await _loadSettings(displayName: displayName, email: email);
    } else {
      _userName = 'User';
      _userEmail = 'user@example.com';
      _profileImagePath = null;
      _notificationsEnabled = true;
      _biometricEnabled = false;
      _selectedCurrency = 'USD';
      _isReady = true;
      notifyListeners();
    }
  }

  Future<void> _loadSettings({String? displayName, String? email}) async {
    if (_userId == null) return;

    _box = await Hive.openBox<dynamic>('settings_$_userId');

    // 1. Adaptive Loading Logic
    if (_box!.isNotEmpty) {
      _applyLocalSettings(displayName, email);
      _isReady = true;
      notifyListeners();
    } else {
      // Fresh Install: Wait for Cloud Restore
      await _restoreSettingsFromCloud();
      _applyLocalSettings(displayName, email);
      _isReady = true;
      notifyListeners();
    }

    // 3. Background Sync for Username Restoration
    _performCloudSyncBackground();
  }

  void _applyLocalSettings(String? displayName, String? email) {
    if (_box == null) return;
    _userName = _box!.get(_nameKey) ?? displayName ?? 'User';
    _userEmail = _box!.get(_emailKey) ?? email ?? 'user@example.com';
    _profileImagePath = _box!.get(_imageKey);
    _notificationsEnabled = _box!.get(
      'notifications_enabled',
      defaultValue: true,
    );
    _biometricEnabled = _box!.get(_biometricKey, defaultValue: false);
    _selectedCurrency = _box!.get(_currencyKey, defaultValue: 'USD');

    // Initial local save if missing
    if (!_box!.containsKey(_nameKey) && displayName != null) {
      _box!.put(_nameKey, displayName);
    }
    if (!_box!.containsKey(_emailKey) && email != null) {
      _box!.put(_emailKey, email);
    }
  }

  Future<void> _restoreSettingsFromCloud() async {
    if (_userId == null || _box == null) return;
    try {
      final cloudSettings = await _syncService.pullSettings(_userId!);
      if (cloudSettings != null) {
        for (final entry in cloudSettings.entries) {
          await _box!.put(entry.key, entry.value);
        }
        debugPrint('CloudSync: Settings restored from Firestore.');
      }
    } catch (e) {
      debugPrint('CloudSync restore settings error: $e');
    }
  }

  Future<void> _performCloudSyncBackground() async {
    if (_userId == null || _box == null) return;

    try {
      // Restore settings if local box is empty
      if (_box!.isEmpty) {
        final cloudSettings = await _syncService.pullSettings(_userId!);
        if (cloudSettings != null) {
          for (final entry in cloudSettings.entries) {
            await _box!.put(entry.key, entry.value);
          }
          debugPrint('CloudSync: Settings restored from Firestore.');

          // Refresh local state from restored data
          _userName = _box!.get(_nameKey) ?? _userName;
          _userEmail = _box!.get(_emailKey) ?? _userEmail;
          _selectedCurrency = _box!.get(
            _currencyKey,
            defaultValue: _selectedCurrency,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('CloudSync background settings error: $e');
    }
  }

  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    if (_box != null) {
      await _box!.put(_currencyKey, currency);
    }
    _pushSettingsToCloud();
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
      _pushSettingsToCloud();
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

  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    if (_box != null) {
      await _box!.put(_biometricKey, enabled);
    }
    _pushSettingsToCloud();
    notifyListeners();
  }

  /// Pushes current settings snapshot to Firestore in the background.
  void _pushSettingsToCloud() {
    if (_userId == null) return;
    _syncService.pushSettings(_userId!, {
      _currencyKey: _selectedCurrency,
      _nameKey: _userName,
      _emailKey: _userEmail,
      _biometricKey: _biometricEnabled,
      'notifications_enabled': _notificationsEnabled,
    });
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
