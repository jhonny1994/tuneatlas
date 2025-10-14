import 'package:flutter/material.dart';

/// Represents a supported language in the app
class SupportedLanguage {
  const SupportedLanguage({
    required this.locale,
    required this.nativeName,
  });

  /// The locale code (e.g., 'en', 'ar', 'fr')
  final String locale;

  /// The language name in its native script (e.g., 'English', 'العربية', 'Français')
  final String nativeName;
}

/// Central configuration for all supported languages
/// Add new languages here to make them available throughout the app
class SupportedLanguages {
  SupportedLanguages._();

  /// List of all supported languages
  /// To add a new language:
  /// 1. Add the language here
  /// 2. Create app_{locale}.arb file in lib/src/core/l10n/
  /// 3. Add the locale to l10n.yaml supported-locales
  /// 4. Run: flutter gen-l10n
  static const List<SupportedLanguage> all = [
    SupportedLanguage(
      locale: 'en',
      nativeName: 'English',
    ),
    SupportedLanguage(
      locale: 'ar',
      nativeName: 'العربية',
    ),
    // Add more languages here:
    // SupportedLanguage(
    //   locale: 'fr',
    //   nativeName: 'Français',
    //   englishName: 'French',
    // ),
    // SupportedLanguage(
    //   locale: 'es',
    //   nativeName: 'Español',
    //   englishName: 'Spanish',
    // ),
    // SupportedLanguage(
    //   locale: 'de',
    //   nativeName: 'Deutsch',
    //   englishName: 'German',
    // ),
  ];

  /// Get a language by its locale code
  static SupportedLanguage? getByLocale(String locale) {
    try {
      return all.firstWhere((lang) => lang.locale == locale);
    } on Exception catch (_) {
      return null;
    }
  }

  /// Get all locale objects for MaterialApp
  static List<Locale> get locales =>
      all.map((lang) => Locale(lang.locale)).toList();

  /// Default language (fallback)
  static const SupportedLanguage defaultLanguage = SupportedLanguage(
    locale: 'en',
    nativeName: 'English',
  );
}
