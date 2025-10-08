import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tuneatlas/src/core/core.dart';

/// Discovers Radio Browser API servers using DNS lookup
/// Radio Browser uses multiple servers for load balancing
class ServerDiscovery {
  /// Discover available servers and return a working one
  /// Tries multiple servers with health checks
  Future<String> discoverServer() async {
    try {
      debugPrint('[ServerDiscovery] Looking up servers...');

      // DNS lookup to get all available servers
      final addresses = await InternetAddress.lookup(
        AppConfig.radioBrowserDnsHost,
      );

      if (addresses.isEmpty) {
        throw Exception('No Radio Browser servers found');
      }

      debugPrint('[ServerDiscovery] Found ${addresses.length} servers');

      // Randomize server order for load balancing
      final shuffledAddresses = List<InternetAddress>.from(addresses)
        ..shuffle(Random());

      // Try each server until one works
      for (final address in shuffledAddresses) {
        try {
          final hostname = await _getHostnameFromIp(address.address);
          final serverUrl = 'https://$hostname';

          debugPrint('[ServerDiscovery] Testing server: $serverUrl');

          // Health check - try to reach the API
          final isHealthy = await _healthCheck(serverUrl);

          if (isHealthy) {
            debugPrint(
              '[ServerDiscovery] ✓ Selected working server: $serverUrl',
            );
            return serverUrl;
          }

          debugPrint('[ServerDiscovery] ✗ Server unhealthy, trying next...');
        } on DioException catch (e) {
          debugPrint('[ServerDiscovery] Server failed: $e');
          continue; // Try next server
        }
      }

      throw Exception('No healthy Radio Browser servers found');
    } catch (e) {
      debugPrint('[ServerDiscovery] Failed to discover servers: $e');
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
        debugPrint('[ServerDiscovery] Resolved hostname: $hostname');
        return hostname;
      }
    } on Exception catch (e) {
      debugPrint('[ServerDiscovery] Reverse lookup failed: $e');
    }

    // Fallback to DNS host
    debugPrint('[ServerDiscovery] Using fallback hostname');
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
    } on Exception catch (e) {
      debugPrint('[ServerDiscovery] Health check failed: $e');
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
    } on Exception catch (e) {
      debugPrint('[ServerDiscovery] Server verification failed: $e');
      return false;
    }
  }
}
