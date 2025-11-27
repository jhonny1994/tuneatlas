import 'package:flutter/animation.dart';

/// TuneAtlas "Clarity" Design System Configuration
/// Minimalist, professional, production-grade
/// Strict 4px base unit spacing system
class AppConfig {
  // Prevent instantiation
  AppConfig._();

  // ─────────────────────────────────────────────────────────────────────────
  // App Info
  // ─────────────────────────────────────────────────────────────────────────
  static const String appName = 'TuneAtlas';
  static const String version = '0.1.2';
  static const String userAgent = '$appName/$version (Flutter)';

  // ─────────────────────────────────────────────────────────────────────────
  // API Configuration
  // ─────────────────────────────────────────────────────────────────────────
  static const String radioBrowserDnsHost = 'all.api.radio-browser.info';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration connectTimeout = Duration(seconds: 10);
  static const String countryDetectionUrl = 'https://ipwho.is/';
  static const String deepLinkBaseUrl = 'https://dmar.site/tuneatlas';

  // ─────────────────────────────────────────────────────────────────────────
  // Pagination & Caching
  // ─────────────────────────────────────────────────────────────────────────
  static const int pageSize = 20;
  static const double preloadThreshold = 0.8;
  static const double scrollThresholdPx = 200;
  static const Duration cacheDuration = Duration(days: 7);

  // ─────────────────────────────────────────────────────────────────────────
  // Storage Limits
  // ─────────────────────────────────────────────────────────────────────────
  static const int maxRecents = 15;
  static const int maxFavorites = 100;
  static const int maxDiscoverTags = 100;

  // List Performance
  // ─────────────────────────────────────────────────────────────────────────
  static const double listCacheExtent = 500;
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // ─────────────────────────────────────────────────────────────────────────
  // Spacing Scale - 4px base unit
  // ─────────────────────────────────────────────────────────────────────────
  static const double space0 = 0;
  static const double space1 = 4; // xs
  static const double space2 = 8; // sm
  static const double space3 = 12; // md
  static const double space4 = 16; // lg
  static const double space5 = 20;
  static const double space6 = 24; // xl
  static const double space8 = 32; // 2xl
  static const double space10 = 40;
  static const double space12 = 48; // 3xl

  // Semantic spacing aliases (for compatibility)
  static const double spacingXS = space1; // 4
  static const double spacingS = space2; // 8
  static const double spacingM = space4; // 16
  static const double spacingL = space6; // 24
  static const double spacingXL = space8; // 32
  static const double spacingXXL = space12; // 48

  // ─────────────────────────────────────────────────────────────────────────
  // Border Radius - Unified scale
  // ─────────────────────────────────────────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusSm = 4; // Chips, badges
  static const double radiusMd = 8; // Buttons, inputs, images
  static const double radiusLg = 12; // Cards
  static const double radiusXl = 16; // Bottom sheets, dialogs
  static const double radiusFull = 999; // Pills, avatars

  // Semantic aliases (for compatibility)
  static const double radiusChip = radiusSm;
  static const double radiusImage = radiusMd;
  static const double radiusInput = radiusMd;
  static const double radiusCard = radiusLg;

  // ─────────────────────────────────────────────────────────────────────────
  // Component Sizes
  // ─────────────────────────────────────────────────────────────────────────

  // Icons
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;
  static const double icon2xl = 64;

  // Legacy aliases
  static const double iconSizeSmall = iconSm;
  static const double iconSizeFallback = iconLg;
  static const double iconSizeLarge = iconXl;

  // Touch targets
  static const double touchTargetMin = 44; // Accessibility minimum
  static const double buttonHeight = 44;
  static const double buttonHeightLg = 48;

  // Station card
  static const double stationImageSize = 56;
  static const double stationImageSizeLg = 64;

  // Mini player
  static const double miniPlayerHeight = 64;
  static const double miniPlayerImageSize = 48;

  // Onboarding
  static const double onboardingIconContainerSize = 120;
  static const double onboardingIconSize = 60;

  // ─────────────────────────────────────────────────────────────────────────
  // Padding Presets
  // ─────────────────────────────────────────────────────────────────────────
  static const double paddingScreen = space4; // 16
  static const double paddingCard = space3; // 12
  static const double paddingContent = space6; // 24

  // ─────────────────────────────────────────────────────────────────────────
  // Animation
  // ─────────────────────────────────────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationShimmer = Duration(milliseconds: 1200);

  // Legacy aliases
  static const Duration fastAnimation = durationFast;
  static const Duration normalAnimation = durationNormal;
  static const Duration slowAnimation = durationSlow;
  static const Duration shimmerDuration = durationShimmer;

  // Curves
  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeOutExpo;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveAccelerate = Curves.easeIn;

  // Legacy aliases
  static const Curve defaultCurve = curveDefault;
  static const Curve emphasizedCurve = curveEmphasized;
  static const Curve deceleratedCurve = curveDecelerate;
  static const Curve acceleratedCurve = curveAccelerate;

  // Stagger animation
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const int maxStaggerItems = 20;
  static const double staggerOffset = 24; // Reduced from 50 for subtlety

  // ─────────────────────────────────────────────────────────────────────────
  // Micro-interactions
  // ─────────────────────────────────────────────────────────────────────────
  static const bool enableHaptics = true;
  static const double pressedScale = 0.98; // Subtle press feedback
  static const double pressedOpacity = 0.8;

  // ─────────────────────────────────────────────────────────────────────────
  // Deprecated - keeping for compatibility, use new names
  // ─────────────────────────────────────────────────────────────────────────
  @Deprecated('Use radiusCard instead')
  static const double cardBorderRadius = radiusCard;
  @Deprecated('Use 0 for flat design')
  static const double cardElevation = 0;
  @Deprecated('Use pressedScale instead')
  static const double pressedRotation = 0;
  @Deprecated('Use pressedScale instead')
  static const double hoveredScale = 1.02;
}
