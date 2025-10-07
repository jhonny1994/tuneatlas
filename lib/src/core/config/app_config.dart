/// Central configuration for the entire app.
/// All constants live here - no magic numbers in code.
class AppConfig {
  // Prevent instantiation
  AppConfig._();

  // App Info
  static const String appName = 'TuneAtlas';
  static const String version = '0.1.0';
  static const String userAgent = '$appName/$version';

  // Radio Browser API Configuration
  static const String radioBrowserDnsHost = 'all.api.radio-browser.info';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 10);

  // Country Detection
  static const String countryDetectionUrl = 'https://api.country.is/';

  // Pagination
  static const int pageSize = 20;
  static const double preloadThreshold = 0.8; // Load more at 80% scroll

  // Caching
  static const Duration cacheDuration = Duration(days: 7);

  // Storage Limits
  static const int maxRecents = 15;
  static const int maxFavorites = 100;

  // UI Constants
  static const double cardBorderRadius = 16;
  static const double cardElevation = 2;
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
}
