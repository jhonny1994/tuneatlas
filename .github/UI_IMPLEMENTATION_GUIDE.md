# ⚠️ DEPRECATED - See STEP_BY_STEP_GUIDE.md Instead

> **Note:** This document contains code examples that don't align with your existing component structure. Following these examples would require rewriting entire components.
>
> **✅ Use instead:**
> - `STEP_BY_STEP_GUIDE.md` - Exact line-by-line modifications to your existing code
> - `REALISTIC_UI_ENHANCEMENTS.md` - Explains what and why we're enhancing
> - `IMPLEMENTATION_CHECKLIST.md` - Quick reference checklist

---

# TuneAtlas UI Implementation Guide 🛠️

## Quick Start: 5 High-Impact Changes (4-6 hours total)

This guide provides **copy-paste ready code** for immediate visual improvements.

---

## 1. Gradient Station Cards (⏱️ 1-2 hours)

### Create Gradient Palette Manager

Create: `lib/src/core/config/audio_gradients.dart`

```dart
import 'package:flutter/material.dart';

/// Genre-based gradient palettes for audio-visual storytelling
class AudioGradients {
  AudioGradients._();

  // Default/Unknown genre
  static const cosmic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF14D8CC), // T-Sharp cyan
      Color(0xFF667EEA), // Purple
      Color(0xFF764BA2), // Deep purple
    ],
  );

  // Pop, Electronic, Dance
  static const vibrant = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B9D), // Pink
      Color(0xFFC239B4), // Magenta
      Color(0xFF6B4FFF), // Purple
    ],
  );

  // Rock, Metal, Alternative
  static const energy = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF512F), // Orange-red
      Color(0xFFF09819), // Gold
    ],
  );

  // Classical, Jazz, Ambient
  static const serenity = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA), // Soft blue
      Color(0xFF764BA2), // Purple
      Color(0xFFF093FB), // Light purple
    ],
  );

  // News, Talk, Sports
  static const focus = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4E54C8), // Navy
      Color(0xFF8F94FB), // Light blue
    ],
  );

  // World, Ethnic, Cultural
  static const world = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFA8BFF), // Pink
      Color(0xFF2BD2FF), // Cyan
      Color(0xFF2BFF88), // Green
    ],
  );

  // Hip-Hop, R&B, Soul
  static const urban = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFee0979), // Hot pink
      Color(0xFFff6a00), // Orange
    ],
  );

  // Country, Folk, Acoustic
  static const organic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD89B), // Warm yellow
      Color(0xFF19547B), // Teal
    ],
  );

  /// Get gradient based on station tags/genre
  static LinearGradient forStation(Station station) {
    final tags = (station.tags ?? '').toLowerCase();
    final language = (station.language ?? '').toLowerCase();
    final name = station.name.toLowerCase();

    // Check for genre keywords
    if (_containsAny(tags, ['pop', 'electronic', 'dance', 'edm', 'house'])) {
      return vibrant;
    }
    if (_containsAny(tags, ['rock', 'metal', 'punk', 'alternative'])) {
      return energy;
    }
    if (_containsAny(tags, ['classical', 'jazz', 'ambient', 'instrumental'])) {
      return serenity;
    }
    if (_containsAny(tags, ['news', 'talk', 'sports', 'podcast'])) {
      return focus;
    }
    if (_containsAny(tags, ['world', 'ethnic', 'traditional', 'folk'])) {
      return world;
    }
    if (_containsAny(tags, ['hip-hop', 'rap', 'r&b', 'soul', 'urban'])) {
      return urban;
    }
    if (_containsAny(tags, ['country', 'bluegrass', 'acoustic'])) {
      return organic;
    }

    // Fallback to cosmic gradient
    return cosmic;
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  /// Get animated gradient shimmer overlay
  static LinearGradient shimmer({
    required double animationValue, // 0.0 to 1.0
  }) {
    return LinearGradient(
      begin: Alignment(-1.0 + (animationValue * 2.0), -1.0),
      end: Alignment(1.0 + (animationValue * 2.0), 1.0),
      colors: const [
        Colors.transparent,
        Color(0x1AFFFFFF),
        Colors.transparent,
      ],
    );
  }
}
```

### Update Station Card with Gradients

Modify: `lib/src/features/home/presentation/widgets/station_card.dart`

Add these changes:

```dart
// At the top of the file
import 'dart:ui' show ImageFilter;

// Inside _buildCard method, replace Card widget:
return AnimatedScale(
  scale: _isPressed ? AppConfig.pressedScale : 1.0,
  duration: AppConfig.fastAnimation,
  curve: AppConfig.defaultCurve,
  child: Stack(
    children: [
      // Gradient background
      Container(
        height: 96, // Card height
        decoration: BoxDecoration(
          gradient: AudioGradients.forStation(widget.station),
          borderRadius: BorderRadius.circular(AppConfig.radiusCard),
        ),
      ),
      
      // Glassmorphic overlay
      ClipRRect(
        borderRadius: BorderRadius.circular(AppConfig.radiusCard),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppConfig.radiusCard),
              border: isCurrentStation
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    )
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                borderRadius: BorderRadius.circular(AppConfig.radiusCard),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Station logo with elevated shadow
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppConfig.radiusImage),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _buildLogo(context),
                      ),
                      const SizedBox(width: 12),

                      // Rest of card content (existing code)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Station name - make bold and white for contrast
                            Text(
                              widget.station.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            _buildMetadata(context),
                          ],
                        ),
                      ),

                      // Play/pause and favorite buttons (existing code)
                      if (isCurrentStation) ...[
                        const SizedBox(width: 8),
                        if (isLoadingAudio)
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () => ref
                                .read(audioPlayerProvider.notifier)
                                .togglePlayPause(),
                          ),
                      ],
                      
                      IconButton(
                        onPressed: _isLoading ? null : _toggleFavorite,
                        icon: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite
                                    ? const Color(0xFFFF6B9D)
                                    : Colors.white,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
```

---

## 2. Glassmorphic Mini Player (⏱️ 2-3 hours)

### Enhanced Mini Player with Gradient & Blur

Modify: `lib/src/features/player/presentation/widgets/mini_player.dart`

Replace the Container in `_buildMiniPlayer` with:

```dart
Stack(
  children: [
    // Gradient background
    Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: state.currentStation != null
            ? AudioGradients.forStation(state.currentStation!)
            : AudioGradients.cosmic,
      ),
    ),
    
    // Glassmorphic overlay
    ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated gradient progress bar
              if (state.isPlaying)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) {
                    return Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1.0 + (value * 2.0), 0),
                          end: Alignment(1.0 + (value * 2.0), 0),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    // Loop animation
                  },
                ),
              
              // Error banner (if error exists)
              if (state.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(alpha: 0.9),
                    backgroundBlendMode: BlendMode.overlay,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Main player controls
              SizedBox(
                height: 72,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Station logo with glow effect
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: station.favicon.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: station.favicon,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 56,
                                    height: 56,
                                    color: theme.colorScheme.surfaceContainerHigh,
                                    child: Icon(
                                      Icons.radio,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 56,
                                    height: 56,
                                    color: theme.colorScheme.surfaceContainerHigh,
                                    child: Icon(
                                      Icons.radio,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 56,
                                  height: 56,
                                  color: theme.colorScheme.surfaceContainerHigh,
                                  child: Icon(
                                    Icons.radio,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Station info (existing code - but add white text)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              station.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (state.error != null)
                                  Icon(
                                    Icons.error,
                                    size: 12,
                                    color: theme.colorScheme.error,
                                  ),
                                if (state.isLoading && state.error == null)
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (!state.isLoading && state.error == null)
                                  Icon(
                                    Icons.radio_button_checked,
                                    size: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    state.error != null
                                        ? 'Error'
                                        : (state.isLoading
                                            ? 'Connecting...'
                                            : 'Live'),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Play/pause/stop buttons (existing code - add glass effect)
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.error != null)
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () async {
                                  unawaited(Haptics.light());
                                  await ref
                                      .read(audioPlayerProvider.notifier)
                                      .playStation(station);
                                },
                              )
                            else
                              IconButton(
                                icon: Icon(
                                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                                onPressed: () async {
                                  unawaited(Haptics.light());
                                  await ref
                                      .read(audioPlayerProvider.notifier)
                                      .togglePlayPause();
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                unawaited(Haptics.light());
                                await ref.read(audioPlayerProvider.notifier).stop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)
```

---

## 3. Waveform Animation Widget (⏱️ 1-2 hours)

### Create Animated Waveform

Create: `lib/src/core/widgets/live_waveform.dart`

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated waveform bars that simulate audio levels
class LiveWaveform extends StatefulWidget {
  const LiveWaveform({
    this.barCount = 15,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.color,
    this.maxHeight = 24.0,
    this.animationSpeed = const Duration(milliseconds: 150),
    super.key,
  });

  final int barCount;
  final double barWidth;
  final double barSpacing;
  final Color? color;
  final double maxHeight;
  final Duration animationSpeed;

  @override
  State<LiveWaveform> createState() => _LiveWaveformState();
}

class _LiveWaveformState extends State<LiveWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize bar heights
    for (var i = 0; i < widget.barCount; i++) {
      _barHeights.add(_random.nextDouble());
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationSpeed,
    )..addListener(_updateBarHeights);

    _controller.repeat();
  }

  void _updateBarHeights() {
    setState(() {
      for (var i = 0; i < _barHeights.length; i++) {
        // Smooth random walk for natural audio feel
        final change = (_random.nextDouble() - 0.5) * 0.3;
        _barHeights[i] = (_barHeights[i] + change).clamp(0.1, 1.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      height: widget.maxHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.barCount, (index) {
          final height = _barHeights[index] * widget.maxHeight;
          
          return Padding(
            padding: EdgeInsets.only(
              right: index < widget.barCount - 1 ? widget.barSpacing : 0,
            ),
            child: AnimatedContainer(
              duration: widget.animationSpeed,
              curve: Curves.easeInOut,
              width: widget.barWidth,
              height: height,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(widget.barWidth / 2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Gradient waveform variant
class GradientWaveform extends StatelessWidget {
  const GradientWaveform({
    this.barCount = 15,
    this.gradient,
    super.key,
  });

  final int barCount;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return (gradient ??
                LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ))
            .createShader(bounds);
      },
      child: LiveWaveform(barCount: barCount),
    );
  }
}
```

### Add Waveform to Station Cards & Mini Player

In `station_card.dart`, add below station name:

```dart
if (isCurrentStation && isPlaying)
  Padding(
    padding: const EdgeInsets.only(top: 4),
    child: LiveWaveform(
      barCount: 12,
      barWidth: 2,
      maxHeight: 16,
      color: Colors.white.withValues(alpha: 0.8),
    ),
  ),
```

In `mini_player.dart`, add in the info section:

```dart
if (state.isPlaying && state.error == null)
  const LiveWaveform(
    barCount: 20,
    barWidth: 2,
    barSpacing: 2,
    maxHeight: 20,
  ),
```

---

## 4. Enhanced Typography (⏱️ 30 min)

### Create Typography Scale

Create: `lib/src/core/config/audio_typography.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TuneAtlas Expressive Typography System
class AudioTypography {
  AudioTypography._();

  // Display - Hero moments (Now Playing screen)
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  // Headline - Section titles
  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // Title - Card station names
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // Body - Content text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // Label - Tags, chips, captions
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.5,
      );
}
```

### Apply Typography

Update screen titles to use new scale:

```dart
// In home_screen.dart, discover_screen.dart, etc.
title: Text(
  'TuneAtlas',
  style: AudioTypography.headlineMedium.copyWith(
    color: theme.colorScheme.onSurface,
  ),
),
```

---

## 5. Improved Empty States with Lottie (⏱️ 1 hour)

### Download Lottie Animations

1. Visit https://lottiefiles.com/
2. Search for:
   - "radio" → save as `radio_search.json`
   - "heart" → save as `heart_empty.json`
   - "search" → save as `magnifying_glass.json`
   - "signal" → save as `network_error.json`

3. Create `assets/lottie/` directory
4. Add animations to folder

### Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/lottie/
```

### Enhanced Empty State Widget

Modify: `lib/src/core/widgets/empty_state_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tuneatlas/src/src.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    required this.message,
    this.icon,
    this.lottieAsset, // NEW: Optional Lottie animation
    this.action,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final IconData? icon;
  final String? lottieAsset; // NEW
  final String title;
  final String message;
  final IconData? action;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.paddingContent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon or Lottie
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                size: AppConfig.iconSizeLarge,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                semanticLabel: 'Empty state',
              ),
            
            const SizedBox(height: AppConfig.spacingL),
            
            // Gradient text title
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ).createShader(bounds),
              child: Text(
                title,
                style: AudioTypography.headlineMedium.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppConfig.spacingS),
            
            Text(
              message,
              style: AudioTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            if (action != null &&
                actionLabel != null &&
                onActionPressed != null) ...[
              const SizedBox(height: AppConfig.spacingL),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: Icon(action),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, AppConfig.buttonHeight),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Usage Example

```dart
// In library_screen.dart for empty favorites
EmptyStateWidget(
  lottieAsset: 'assets/lottie/heart_empty.json',
  title: 'No favorites yet',
  message: 'Add stations to your favorites by tapping the heart icon',
)
```

---

## 6. Bonus: Floating Action Button with Glow

### Add Glowing Search FAB

In `home_screen.dart`:

```dart
floatingActionButton: Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: theme.colorScheme.primary.withValues(alpha: 0.5),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  ),
  child: FloatingActionButton(
    onPressed: () {
      unawaited(Haptics.light());
      context.go('/search');
    },
    child: const Icon(Icons.search),
  ),
),
```

---

## Testing Checklist

After implementing these changes:

- [ ] Cards have gradient backgrounds
- [ ] Glassmorphism visible on mini player
- [ ] Waveform animates when playing
- [ ] Typography looks bolder and more expressive
- [ ] Empty states show Lottie animations
- [ ] All interactions have haptic feedback
- [ ] Performance is smooth (60fps)
- [ ] Dark theme looks good
- [ ] Accessibility maintained

---

## Next Steps

After these quick wins, proceed to:

1. **Full Now Playing Screen** - Immersive expansion sheet
2. **Genre Discovery** - Interactive bubble UI
3. **Performance Optimization** - RepaintBoundary, caching
4. **Accessibility Audit** - WCAG AA compliance

---

**Implementation Time:** 4-6 hours total
**Impact:** High - Transforms app from basic to premium
**Difficulty:** Medium - Copy-paste with minor adjustments

🚀 **Ready to implement? Start with gradients for maximum visual impact!**
