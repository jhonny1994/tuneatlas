import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/storage/shared_prefs_provider.dart';

part 'theme_provider.g.dart';

/// Theme mode provider with persistence
/// Reads from SharedPreferences and allows switching themes
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    // Read saved theme from SharedPreferences
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedTheme = prefs.getString(_key);

    if (savedTheme == 'light') return ThemeMode.light;
    if (savedTheme == 'system') return ThemeMode.system;
    return ThemeMode.system; // Default to system
  }

  /// Switch to dark theme
  Future<void> setDarkMode() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, 'dark');
    state = ThemeMode.dark;
  }

  /// Switch to light theme
  Future<void> setLightMode() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, 'light');
    state = ThemeMode.light;
  }

  /// Switch to system theme (follows device settings)
  Future<void> setSystemMode() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, 'system');
    state = ThemeMode.system;
  }

  /// Toggle between light and dark
  Future<void> toggle() async {
    if (state == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }
}
