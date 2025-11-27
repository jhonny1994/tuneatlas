import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_deep_link_provider.g.dart';

/// Stores a deep link that needs to be handled after onboarding completes
@Riverpod(keepAlive: true)
class PendingDeepLink extends _$PendingDeepLink {
  @override
  String? build() {
    return null;
  }

  void set(String path) {
    state = path;
  }

  void clear() {
    state = null;
  }
}
