import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TuneAtlas "Marquee" Design System
/// Using Material 3 dynamic color generation from T-Sharp seed
class AppTheme {
  AppTheme._();

  // Core Brand Colors
  static const Color tSharp = Color(0xFF14D8CC); // Primary seed (vibrant cyan)
  static const Color ink = Color(0xFF1C203C); // Custom background
  static const Color gold = Color(0xFFFEC25A); // Custom accent

  /// Dark Theme (Default) - Material 3 Generated
  static ThemeData darkTheme() {
    // Let Material 3 generate harmonious colors from T-Sharp seed
    final colorScheme = ColorScheme.fromSeed(
      seedColor: tSharp,
      brightness: Brightness.dark,
      // Override only specific colors we want custom
      surface: ink,
      onSurface: const Color(0xFFF5F5F5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ink,

      // Typography using Google Fonts
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card (slightly lighter than ink for depth)
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ink,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      ),

      // Filled Button (Material 3 primary button)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0, // Material 3 uses 0 elevation for filled buttons
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Light Theme - Material 3 Generated
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: tSharp,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom Navigation
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      ),

      // Filled Button (Material 3 primary button)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0, // Material 3 uses 0 elevation for filled buttons
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
