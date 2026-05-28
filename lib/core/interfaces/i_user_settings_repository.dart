abstract class IUserSettingsRepository {
  Future<void> init(String userId);
  T? get<T>(String key, {T? defaultValue});
  Future<void> put(String key, dynamic value);
  Future<void> delete(String key);
  bool get isEmpty;
  Future<Map<String, dynamic>?> pullFromCloud();
  Future<void> pushToCloud(Map<String, dynamic> settings);
  void dispose();
}
