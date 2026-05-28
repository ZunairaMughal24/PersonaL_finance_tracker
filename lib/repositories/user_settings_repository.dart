import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/core/interfaces/i_user_settings_repository.dart';
import 'package:montage/core/interfaces/i_firestore_sync_service.dart';
import 'package:montage/services/firestore_sync_service.dart';
import 'package:montage/core/constants/app_keys.dart';

class UserSettingsRepository implements IUserSettingsRepository {
  final IFirestoreSyncService _syncService;
  Box? _box;
  String? _userId;

  UserSettingsRepository({IFirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  @override
  Future<void> init(String userId) async {
    if (_userId == userId && _box != null) return;
    _userId = userId;
    _box = await Hive.openBox(AppKeys.userSettings(userId));
  }

  @override
  T? get<T>(String key, {T? defaultValue}) {
    return _box?.get(key, defaultValue: defaultValue) as T?;
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  @override
  bool get isEmpty => _box?.isEmpty ?? true;

  @override
  Future<void> pushToCloud(Map<String, dynamic> settings) async {
    if (_userId != null) {
      await _syncService.pushSettings(_userId!, settings);
    }
  }

  @override
  Future<Map<String, dynamic>?> pullFromCloud() async {
    if (_userId == null) return null;
    return await _syncService.pullSettings(_userId!);
  }

  @override
  void dispose() {
    _box?.close();
    _box = null;
    _userId = null;
  }
}
