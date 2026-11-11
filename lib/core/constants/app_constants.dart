/// Centralized application constants used across the Vehicle Pooling App.
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Metadata
  static const String appName = 'Vehicle Pooling';
  static const String appTagline = 'Share rides, reduce emissions, save costs';
  static const String appVersion = '1.0.0';

  // Layout & Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Asset Paths
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String fontPath = 'assets/fonts/';

  // Storage Keys (Ready for future local persistence)
  static const String authTokenKey = 'auth_token';
  static const String currentUserIdKey = 'current_user_id';
  static const String themeModeKey = 'theme_mode_preference';
}
