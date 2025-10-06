import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tuneatlas/src/src.dart';

part 'theme_provider.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  static const _themePrefsKey = 'appTheme';

  @override
  ThemeMode build() {
    // Load the saved theme mode from SharedPreferences
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(_themePrefsKey);
    if (themeIndex != null) {
      return ThemeMode.values[themeIndex];
    }
    // Default to system theme if nothing is saved
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themePrefsKey, mode.index);
    state = mode;
  }
}
