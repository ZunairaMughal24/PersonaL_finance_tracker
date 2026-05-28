class AppKeys {
  // User Settings Keys
  static const String currency = 'selected_currency';
  static const String userName = 'user_name';
  static const String profileImage = 'profile_image_path';
  static const String userEmail = 'user_email';
  static const String biometricEnabled = 'biometric_enabled';
  static const String notificationsEnabled = 'notifications_enabled';

  // Repository Box Names
  static String customCategories(String userId) => 'custom_categories_$userId';
  static String userSettings(String userId) => 'user_settings_$userId';
  static String transactions(String userId) => 'transactions_$userId';
}
