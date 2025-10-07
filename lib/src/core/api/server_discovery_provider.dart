import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';

part 'server_discovery_provider.g.dart';

/// Provides ServerDiscovery instance
@riverpod
ServerDiscovery serverDiscovery(Ref ref) {
  return ServerDiscovery();
}
