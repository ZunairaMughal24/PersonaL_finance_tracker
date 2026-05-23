import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/services/firestore_sync_service.dart';

class UserSettingsRepository {
  final FirestoreSyncService _syncService;
  Box? _box;
  String? _userId;

  UserSettingsRepository({FirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  Future<void> init(String userId) async {
    if (_userId == userId && _box != null) return;
    _userId = userId;
    _box = await Hive.openBox('settings_$userId');
  }

  dynamic get(String key, {dynamic defaultValue}) {
    return _box?.get(key, defaultValue: defaultValue);
  }

  Future<void> put(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  bool get isEmpty => _box?.isEmpty ?? true;

  Future<void> pushToCloud(Map<String, dynamic> settings) async {
    if (_userId != null) {
      await _syncService.pushSettings(_userId!, settings);
    }
  }

  Future<Map<String, dynamic>?> pullFromCloud() async {
    if (_userId == null) return null;
    return await _syncService.pullSettings(_userId!);
  }

  void dispose() {
    _box?.close();
    _box = null;
    _userId = null;
  }
}
