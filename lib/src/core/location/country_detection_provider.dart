import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';

part 'country_detection_provider.g.dart';

/// Detects user's country based on IP address
@Riverpod(keepAlive: true)
Future<String> userCountry(Ref ref) async {
  try {
    debugPrint('[CountryDetection] Detecting user country...');

    final dio = Dio();
    final response = await dio.get<Map<String, dynamic>>(
      AppConfig.countryDetectionUrl,
    );

    final countryCode = response.data?['country'] as String?;

    if (countryCode == null || countryCode.isEmpty) {
      throw Exception('Country code not found in response');
    }

    debugPrint('[CountryDetection] Detected country: $countryCode');
    return countryCode.toUpperCase(); // e.g., "US", "GB", "DE"
  } on DioException catch (e) {
    debugPrint('[CountryDetection] Failed to detect country: $e');
    // Fallback to US if detection fails
    return 'US';
  }
}
