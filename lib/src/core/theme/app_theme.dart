import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuneatlas/src/src.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: tSharp,
    onPrimary: ink,
    secondary: gold,
    onSecondary: ink,
    surface: offWhite,
    onSurface: nearBlack,
    error: coral,
  ),
  textTheme: GoogleFonts.manropeTextTheme().copyWith(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    bodyLarge: const TextStyle(fontSize: 16),
    bodyMedium: const TextStyle(fontSize: 14),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
);

// --- TuneAtlas Dark Theme ---
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: tSharp,
    onPrimary: ink,
    secondary: gold,
    onSecondary: ink,
    surface: ink,
    onSurface: offWhite,
    error: coral,
    onError: Colors.white,
  ),
  textTheme: GoogleFonts.manropeTextTheme().copyWith(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: offWhite,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: offWhite,
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: offWhite,
    ),
    bodyLarge: const TextStyle(fontSize: 16, color: offWhite),
    bodyMedium: const TextStyle(fontSize: 14, color: offWhite),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: offWhite,
    ),
  ),
);
