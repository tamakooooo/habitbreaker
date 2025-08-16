class AppConstants {
  // App Info
  static const String appName = '戒断不良习惯';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.habitbreaker.com';
  static const String apiVersion = '/v1';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // Hive Box Names
  static const String settingsBox = 'settings';
  static const String habitsBox = 'habits';
  static const String recordsBox = 'records';
  
  // Notification Channels
  static const String habitReminderChannel = 'habit_reminder';
  static const String achievementChannel = 'achievement';
  
  // Time Constants
  static const Duration debounceDuration = Duration(milliseconds: 500);
  static const Duration cacheDuration = Duration(hours: 1);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}