import 'package:flutter/animation.dart';

/// Central configuration for the entire app.
/// All constants live here - no magic numbers in code.
class AppConfig {
  // Prevent instantiation
  AppConfig._();

  // App Info
  static const String appName = 'TuneAtlas';
  static const String version = '0.1.0';
  static const String userAgent = '$appName/$version (Flutter)';

  // Radio Browser API Configuration
  static const String radioBrowserDnsHost = 'all.api.radio-browser.info';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 10);

  // Country Detection
  static const String countryDetectionUrl = 'https://ipwho.is/';

  // Pagination
  static const int pageSize = 20;
  static const double preloadThreshold = 0.8; // Load more at 80% scroll
  static const double scrollThresholdPx =
      200; // Pixels from bottom to trigger load

  // Caching
  static const Duration cacheDuration = Duration(days: 7);

  // Storage Limits
  static const int maxRecents = 15;
  static const int maxFavorites = 100;

  // UI Constants
  static const double cardBorderRadius = 16;
  static const double cardElevation = 2;
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeOutExpo;
  static const Curve deceleratedCurve = Curves.easeOut;
  static const Curve acceleratedCurve = Curves.easeIn;

  // Stagger Animation
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const int maxStaggerItems = 20; // Prevent excessive stagger
  static const double staggerOffset = 50; // Vertical slide offset in pixels

  // Haptic Feedback
  static const bool enableHaptics = true; // Feature flag for haptic feedback

  // Micro-interaction Settings
  static const double pressedScale = 0.97; // Scale factor when pressing cards
  static const double pressedRotation = -0.002; // Rotation when pressing cards
  static const double hoveredScale =
      1.02; // Scale factor on hover (web/desktop)

  // UI Constants
  static const double buttonHeight = 48; // Standard button height
  static const double iconSizeLarge = 80; // Large icon size for empty states
  static const double iconSizeSmall = 20; // Small icon size
  static const double iconSizeFallback = 32; // Fallback icon size
  static const double miniPlayerHeight = 72; // Height of the mini player
  static const double miniPlayerImageSize = 56; // Size of album art in mini player

  // Border Radius
  static const double radiusCard = 16; // Cards and surfaces
  static const double radiusInput = 12; // Input fields and interactive elements
  static const double radiusImage = 8; // Images and thumbnails
  static const double radiusChip = 4; // Small chips and badges

  // Spacing Scale
  static const double spacingXXL = 48; // Extra large spacing
  static const double spacingXL = 32; // Large spacing
  static const double spacingL = 24; // Medium-large spacing
  static const double spacingM = 16; // Medium spacing
  static const double spacingS = 8; // Small spacing
  static const double spacingXS = 4; // Extra small spacing

  // Padding
  static const double paddingScreen = 16; // Standard screen/list padding
  static const double paddingContent = 32; // Content area padding
  static const double paddingCard = 12; // Card internal padding
}
