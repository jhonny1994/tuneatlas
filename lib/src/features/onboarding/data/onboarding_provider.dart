import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'onboarding_provider.g.dart';

/// Manages onboarding completion state
@Riverpod(keepAlive: true)
class OnboardingState extends _$OnboardingState {
  static const _key = 'onboarding_completed';

  @override
  bool build() {
    // Check if onboarding has been completed
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> complete() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, true);
    state = true;
  }

  /// Reset onboarding (for testing)
  Future<void> reset() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, false);
    state = false;
  }
}
