import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching user's country
class CountryCacheService {
  CountryCacheService._();
  static final CountryCacheService instance = CountryCacheService._();

  static const String _countryKey = 'cached_country';
  static const String _timestampKey = 'cached_country_timestamp';

  /// Get cached country if available and not expired
  Future<String?> getCachedCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final country = prefs.getString(_countryKey);
      final timestamp = prefs.getInt(_timestampKey);

      if (country == null || timestamp == null) {
        debugPrint('[CountryCache] No cached country found');
        return null;
      }

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final age = now.difference(cachedTime);

      // Cache valid for 7 days
      if (age.inDays >= 7) {
        debugPrint(
          '[CountryCache] Cached country expired (${age.inDays} days old)',
        );
        return null;
      }

      debugPrint(
        '[CountryCache] Using cached country: $country (${age.inDays} days old)',
      );
      return country;
    } on Exception catch (e) {
      debugPrint('[CountryCache] Error reading cache: $e');
      return null;
    }
  }

  /// Cache country with timestamp
  Future<void> cacheCountry(String countryCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_countryKey, countryCode);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);

      debugPrint('[CountryCache] Cached country: $countryCode');
    } on Exception catch (e) {
      debugPrint('[CountryCache] Error writing cache: $e');
    }
  }

  /// Clear cached country
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_countryKey);
      await prefs.remove(_timestampKey);

      debugPrint('[CountryCache] Cache cleared');
    } on Exception catch (e) {
      debugPrint('[CountryCache] Error clearing cache: $e');
    }
  }
}
