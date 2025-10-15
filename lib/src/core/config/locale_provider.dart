import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'locale_provider.g.dart';

/// Locale provider with persistence
/// Reads from SharedPreferences and allows switching locales
/// Dynamically supports all languages defined in SupportedLanguages
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  static const _key = 'locale';

  @override
  Locale build() {
    // Read saved locale from SharedPreferences
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedLocale = prefs.getString(_key);

    // Return saved locale if it's supported
    if (savedLocale != null) {
      final language = SupportedLanguages.getByLocale(savedLocale);
      if (language != null) {
        return Locale(language.locale);
      }
    }

    // Default to the configured default language
    return Locale(SupportedLanguages.defaultLanguage.locale);
  }

  /// Set locale by language code
  /// Validates that the locale is supported before setting
  Future<void> setLocale(String languageCode) async {
    // Validate that the language is supported
    final language = SupportedLanguages.getByLocale(languageCode);
    if (language == null) {
      // Ignore invalid language codes
      return;
    }

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, languageCode);
    state = Locale(languageCode);
  }
}

/// Provider that exposes the currently selected language info
/// This is derived from the current locale
@riverpod
SupportedLanguage currentLanguage(Ref ref) {
  final locale = ref.watch(localeProvider);
  return SupportedLanguages.getByLocale(locale.languageCode) ??
      SupportedLanguages.defaultLanguage;
}
