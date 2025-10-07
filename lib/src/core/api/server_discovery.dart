import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:tuneatlas/src/core/core.dart';

/// Discovers Radio Browser API servers using DNS lookup
/// Radio Browser uses multiple servers for load balancing
class ServerDiscovery {
  /// Discover available servers and return a random one
  /// Throws exception if discovery fails
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

      // Pick a random server for load balancing
      final randomAddress = addresses[Random().nextInt(addresses.length)];
      final serverUrl = 'https://${randomAddress.address}';

      debugPrint('[ServerDiscovery] Selected server: $serverUrl');
      debugPrint('[ServerDiscovery] Found ${addresses.length} total servers');

      return serverUrl;
    } catch (e) {
      debugPrint('[ServerDiscovery] Failed to discover servers: $e');
      throw Exception('Failed to discover Radio Browser servers: $e');
    }
  }

  /// Verify if a server is reachable
  /// Returns true if server responds, false otherwise
  Future<bool> verifyServer(String serverUrl) async {
    try {
      // Try to resolve the hostname
      final uri = Uri.parse(serverUrl);
      if (uri.host.isEmpty) return false;

      final addresses = await InternetAddress.lookup(uri.host);
      return addresses.isNotEmpty;
    } on SocketException catch (e) {
      debugPrint('[ServerDiscovery] Server verification failed: $e');
      return false;
    }
  }
}
