import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'country_detection_provider.g.dart';

/// Detects user's country based on IP address with caching
@Riverpod(keepAlive: true)
Future<String> userCountry(Ref ref) async {
  try {
    debugPrint('[CountryDetection] Detecting user country...');

    // Check cache first
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      debugPrint('[CountryDetection] Using cached country: $cached');
      return cached;
    }

    // No cache, fetch from network
    debugPrint('[CountryDetection] No cache, fetching from network...');

    final dio = Dio();
    final response = await dio.get<Map<String, dynamic>>(
      AppConfig.countryDetectionUrl,
    );

    final countryCode = response.data?['country_code'] as String?;

    if (countryCode == null || countryCode.isEmpty) {
      throw Exception('Country code not found in response');
    }

    final upperCountryCode = countryCode.toUpperCase();
    debugPrint('[CountryDetection] Detected country: $upperCountryCode');

    // Cache the result
    await CountryCacheService.instance.cacheCountry(upperCountryCode);

    return upperCountryCode;
  } on DioException catch (e) {
    debugPrint('[CountryDetection] Network error: $e');

    // Try cache even if expired as fallback
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      debugPrint('[CountryDetection] Using expired cache as fallback: $cached');
      return cached;
    }

    // Last resort fallback
    debugPrint('[CountryDetection] Falling back to US');
    return 'US';
  } on Exception catch (e) {
    debugPrint('[CountryDetection] Error: $e');

    // Try cache as fallback
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      debugPrint('[CountryDetection] Using cache as fallback: $cached');
      return cached;
    }

    return 'US';
  }
}
