import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:tuneatlas/src/src.dart';

/// Discovers Radio Browser API servers using DNS lookup
/// Radio Browser uses multiple servers for load balancing
class ServerDiscovery {
  /// Discover available servers and return a working one
  /// Tries multiple servers with health checks
  Future<String> discoverServer() async {
    try {
      // DNS lookup to get all available servers
      final addresses = await InternetAddress.lookup(
        AppConfig.radioBrowserDnsHost,
      );

      if (addresses.isEmpty) {
        throw Exception('No Radio Browser servers found');
      }

      // Randomize server order for load balancing
      final shuffledAddresses = List<InternetAddress>.from(addresses)
        ..shuffle(Random());

      // Try each server until one works
      for (final address in shuffledAddresses) {
        try {
          final hostname = await _getHostnameFromIp(address.address);
          final serverUrl = 'https://$hostname';

          // Health check - try to reach the API
          final isHealthy = await _healthCheck(serverUrl);

          if (isHealthy) {
            return serverUrl;
          }
        } on DioException {
          continue; // Try next server
        }
      }

      throw Exception('No healthy Radio Browser servers found');
    } catch (e) {
      throw Exception('Failed to discover Radio Browser servers: $e');
    }
  }

  /// Get hostname from IP address via reverse DNS lookup
  Future<String> _getHostnameFromIp(String ipAddress) async {
    try {
      // Try reverse DNS lookup
      final reversedAddress = await InternetAddress(ipAddress).reverse();
      final hostname = reversedAddress.host;

      if (hostname.isNotEmpty && hostname != ipAddress) {
        return hostname;
      }
    } on Exception {
      // Ignore and fallback
    }

    // Fallback to DNS host
    return AppConfig.radioBrowserDnsHost;
  }

  /// Health check - verify server is responding
  Future<bool> _healthCheck(String serverUrl) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      // Try a simple endpoint that should always work
      final response = await dio.get<Map<String, dynamic>>(
        '$serverUrl/json/stats',
      );

      return response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  /// Verify if a server is reachable
  Future<bool> verifyServer(String serverUrl) async {
    try {
      final uri = Uri.parse(serverUrl);
      if (uri.host.isEmpty) return false;

      final addresses = await InternetAddress.lookup(uri.host);
      return addresses.isNotEmpty;
    } on Exception {
      return false;
    }
  }
}
