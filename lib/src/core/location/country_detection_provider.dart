import 'package:dio/dio.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'country_detection_provider.g.dart';

/// Detects user's country based on IP address with caching
@Riverpod(keepAlive: true)
Future<String> userCountry(Ref ref) async {
  try {
    // Check cache first
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      return cached;
    }

    // No cache, fetch from network

    final dio = Dio();
    final response = await dio.get<Map<String, dynamic>>(
      AppConfig.countryDetectionUrl,
    );

    final countryCode = response.data?['country_code'] as String?;

    if (countryCode == null || countryCode.isEmpty) {
      throw Exception('Country code not found in response');
    }

    final upperCountryCode = countryCode.toUpperCase();

    // Cache the result
    await CountryCacheService.instance.cacheCountry(upperCountryCode);

    return upperCountryCode;
  } on DioException {
    // Try cache even if expired as fallback
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      return cached;
    }

    // Last resort fallback
    return 'US';
  } on Exception {
    // Try cache as fallback
    final cached = await CountryCacheService.instance.getCachedCountry();
    if (cached != null) {
      return cached;
    }

    return 'US';
  }
}
