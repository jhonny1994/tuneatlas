# ⚠️ PARTIALLY OUTDATED - See REALISTIC_UI_ENHANCEMENTS.md

**This reference was created before analyzing the actual codebase. Some specs don't match your existing implementation.**

**For accurate specs based on your actual code, see:**

👉 **[REALISTIC_UI_ENHANCEMENTS.md](./REALISTIC_UI_ENHANCEMENTS.md)** 👈

The sections below about **existing** theme colors, typography, and spacing ARE ACCURATE and can still be referenced.

---

# TuneAtlas UI Color & Animation Specs 🎨

## Quick Reference Guide for Developers

---

## 🌈 Color Palette System (PARTIALLY ACCURATE)

### Brand Colors
```dart
// Primary Seed
static const Color tSharp = Color(0xFF14D8CC);  // Vibrant cyan
static const Color ink = Color(0xFF1C203C);     // Dark background
static const Color gold = Color(0xFFFEC25A);    // Accent gold
```

### Genre Gradients (Copy-Paste Ready)

#### Cosmic (Default/Unknown)
```dart
const cosmic = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF14D8CC), // T-Sharp cyan
    Color(0xFF667EEA), // Purple
    Color(0xFF764BA2), // Deep purple
  ],
);
```

#### Vibrant (Pop, Electronic, Dance)
```dart
const vibrant = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFF6B9D), // Pink
    Color(0xFFC239B4), // Magenta
    Color(0xFF6B4FFF), // Purple
  ],
);
```

#### Energy (Rock, Metal)
```dart
const energy = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFF512F), // Orange-red
    Color(0xFFF09819), // Gold
  ],
);
```

#### Serenity (Classical, Jazz)
```dart
const serenity = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF667EEA), // Soft blue
    Color(0xFF764BA2), // Purple
    Color(0xFFF093FB), // Light purple
  ],
);
```

#### Focus (News, Talk)
```dart
const focus = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF4E54C8), // Navy
    Color(0xFF8F94FB), // Light blue
  ],
);
```

#### World (World Music)
```dart
const world = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFA8BFF), // Pink
    Color(0xFF2BD2FF), // Cyan
    Color(0xFF2BFF88), // Green
  ],
);
```

#### Urban (Hip-Hop, R&B)
```dart
const urban = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFee0979), // Hot pink
    Color(0xFFff6a00), // Orange
  ],
);
```

#### Organic (Country, Folk)
```dart
const organic = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFD89B), // Warm yellow
    Color(0xFF19547B), // Teal
  ],
);
```

---

## 🎭 Typography Scale

### Display (Hero Moments)
```dart
// Large - Now Playing Title
TextStyle(
  fontFamily: 'Outfit',
  fontSize: 32,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -0.5,
)

// Medium - Section Headers
TextStyle(
  fontFamily: 'Outfit',
  fontSize: 28,
  fontWeight: FontWeight.w600,
  height: 1.25,
)
```

### Headline (Sections)
```dart
// Large - Screen Titles
TextStyle(
  fontFamily: 'Outfit',
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.3,
)

// Medium - Tab Bar Titles
TextStyle(
  fontFamily: 'Outfit',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 1.3,
)
```

### Title (Cards)
```dart
// Large - Featured Cards
TextStyle(
  fontFamily: 'Inter',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.4,
)

// Medium - Station Names
TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.4,
)

// Small - Subtitles
TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.4,
)
```

### Body (Content)
```dart
// Large - Descriptions
TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
)

// Medium - Standard Text
TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.5,
)

// Small - Captions
TextStyle(
  fontFamily: 'Inter',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.5,
)
```

### Label (Tags, Chips)
```dart
// Large - Buttons
TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.3,
  letterSpacing: 0.1,
)

// Medium - Tags
TextStyle(
  fontFamily: 'Inter',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.3,
  letterSpacing: 0.5,
)

// Small - Chips
TextStyle(
  fontFamily: 'Inter',
  fontSize: 11,
  fontWeight: FontWeight.w600,
  height: 1.3,
  letterSpacing: 0.5,
)
```

---

## 🎬 Animation Timings

### Durations
```dart
static const Duration fastAnimation = Duration(milliseconds: 150);
static const Duration normalAnimation = Duration(milliseconds: 300);
static const Duration slowAnimation = Duration(milliseconds: 500);
static const Duration emphasizedAnimation = Duration(milliseconds: 700);
```

### Curves
```dart
static const Curve defaultCurve = Curves.easeInOutCubic;
static const Curve emphasizedCurve = Curves.easeOutExpo;
static const Curve deceleratedCurve = Curves.easeOut;
static const Curve acceleratedCurve = Curves.easeIn;
static const Curve bounceCurve = Curves.elasticOut;
```

### Animation Patterns

#### Card Press
```dart
AnimatedScale(
  scale: isPressed ? 0.97 : 1.0,
  duration: Duration(milliseconds: 150),
  curve: Curves.easeInOutCubic,
  child: YourCard(),
)
```

#### Page Transition (Fade)
```dart
Duration: 300ms
Curve: Curves.easeInOut
```

#### Page Transition (Slide)
```dart
Duration: 300ms
Curve: Curves.easeInOutCubic
Offset: Offset(1.0, 0.0) // From right
```

#### Sheet Expansion
```dart
Duration: 500ms
Curve: Curves.easeOutExpo
```

#### Stagger List Items
```dart
Duration: 300ms per item
Delay: 50ms between items
Max Items: 20 (performance)
Offset: 50px vertical slide
```

#### Waveform Bars
```dart
Duration: 150ms per update
Curve: Curves.easeInOut
Update Frequency: ~7 times per second
```

---

## 🏔️ Elevation & Shadows

### Card (Resting)
```dart
BoxShadow(
  color: Color(0x1A000000), // 10% black
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

### Floating (Mini Player, FAB)
```dart
BoxShadow(
  color: Color(0x33000000), // 20% black
  blurRadius: 16,
  offset: Offset(0, 4),
)
```

### Modal (Sheets, Dialogs)
```dart
BoxShadow(
  color: Color(0x4D000000), // 30% black
  blurRadius: 24,
  offset: Offset(0, 8),
)
```

### Glow (Active Elements)
```dart
BoxShadow(
  color: primaryColor.withOpacity(0.5),
  blurRadius: 20,
  spreadRadius: 5,
)
```

---

## 🔲 Border Radius Scale

```dart
static const double radiusCard = 16;    // Cards, containers
static const double radiusInput = 12;   // Input fields, buttons
static const double radiusImage = 8;    // Thumbnails, avatars
static const double radiusChip = 4;     // Tags, small badges
```

---

## 📏 Spacing Scale

```dart
static const double spacingXXL = 48;  // Section breaks
static const double spacingXL = 32;   // Large gaps
static const double spacingL = 24;    // Medium-large gaps
static const double spacingM = 16;    // Standard spacing
static const double spacingS = 8;     // Small gaps
static const double spacingXS = 4;    // Minimal spacing
```

### Padding
```dart
static const double paddingScreen = 16;   // Screen edges
static const double paddingContent = 32;  // Content areas
static const double paddingCard = 12;     // Inside cards
```

---

## 🎨 Glassmorphism Effect

### Basic Glass
```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
    decoration: BoxDecoration(
      color: surfaceColor.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: YourContent(),
  ),
)
```

### Intense Glass (Mini Player)
```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
  child: Container(
    decoration: BoxDecoration(
      color: surfaceColor.withOpacity(0.85),
      border: Border(
        top: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
    ),
    child: YourContent(),
  ),
)
```

### Subtle Glass (Cards)
```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  child: Container(
    decoration: BoxDecoration(
      color: surfaceColor.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
    ),
    child: YourContent(),
  ),
)
```

---

## 🌊 Waveform Specs

### Default Config
```dart
barCount: 15
barWidth: 3.0
barSpacing: 2.0
maxHeight: 24.0
animationSpeed: 150ms
```

### Mini Player Variant
```dart
barCount: 20
barWidth: 2.0
barSpacing: 2.0
maxHeight: 20.0
animationSpeed: 150ms
```

### Card Variant
```dart
barCount: 12
barWidth: 2.0
barSpacing: 1.5
maxHeight: 16.0
animationSpeed: 150ms
```

### Full Player Variant
```dart
barCount: 30
barWidth: 4.0
barSpacing: 3.0
maxHeight: 60.0
animationSpeed: 100ms
```

---

## 🎯 Component Size Standards

### Station Card
```dart
Height: 96px (standard)
Logo: 60x60px
Padding: 12px
Border Radius: 16px
```

### Mini Player
```dart
Height: 72px (collapsed)
Logo: 56x56px
Progress Bar: 3px
Border Radius: 0px (full width)
```

### Featured Card (Hero)
```dart
Height: 200px
Logo: 120x120px
Padding: 16px
Border Radius: 20px
```

### Discover Genre Bubble
```dart
Size: 80-120px (variable)
Border Radius: 50% (circle)
Padding: 16px
```

---

## 🖼️ Image Sizing

### Station Logo Sizes
```dart
Small: 40x40px   // List view
Medium: 60x60px  // Card view
Large: 120x120px // Featured/Hero
XLarge: 200x200px // Now Playing
Huge: 300x300px  // Expanded sheet
```

### Placeholder Icons
```dart
Small: 20px
Medium: 32px
Large: 48px
XLarge: 80px
```

---

## 🎨 Gradient Overlay Patterns

### Top Fade (For Images)
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.black.withOpacity(0.7),
    Colors.transparent,
  ],
  stops: [0.0, 0.3],
)
```

### Bottom Fade
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.transparent,
    Colors.black.withOpacity(0.8),
  ],
  stops: [0.6, 1.0],
)
```

### Shimmer Effect
```dart
LinearGradient(
  begin: Alignment(-1.0 + (animation * 2.0), -1.0),
  end: Alignment(1.0 + (animation * 2.0), 1.0),
  colors: [
    Colors.transparent,
    Colors.white.withOpacity(0.1),
    Colors.transparent,
  ],
)
```

---

## 🎛️ Opacity Standards

```dart
Disabled: 0.38
Secondary Text: 0.6
Hint Text: 0.5
Divider: 0.12
Background Scrim: 0.32
Glass Overlay: 0.7-0.85
```

---

## 🔄 State Colors

### Playing State
```dart
Color: Primary (Cyan)
Glow: Primary at 50% opacity
Icon: Icons.pause
```

### Loading State
```dart
Color: OnSurfaceVariant
Spinner: CircularProgressIndicator
Size: 24x24px
```

### Error State
```dart
Color: Error (Red)
Icon: Icons.error_outline
Background: ErrorContainer
```

### Paused State
```dart
Color: OnSurface
Icon: Icons.play_arrow
Opacity: 60%
```

---

## 📱 Responsive Breakpoints

```dart
Mobile: < 600px
Tablet: 600px - 1200px
Desktop: > 1200px
```

### Adaptive Layouts
```dart
// Card columns
Mobile: 1 column
Tablet: 2 columns
Desktop: 3-4 columns

// Padding
Mobile: 16px
Tablet: 24px
Desktop: 32px
```

---

## ⚡ Performance Guidelines

### Blur Radius Limits
```dart
Low: 4-8 (good performance)
Medium: 10-12 (moderate impact)
High: 16+ (use sparingly)
```

### Animation Frame Rates
```dart
Target: 60 FPS
Minimum: 30 FPS
Use RepaintBoundary for complex widgets
```

### Image Caching
```dart
Use: cached_network_image
Max Cache: 100 images
Cache Duration: 7 days
```

---

## 🎨 Quick Copy-Paste Snippets

### Gradient Text
```dart
ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ],
  ).createShader(bounds),
  child: Text(
    'Your Text',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white, // Required for ShaderMask
    ),
  ),
)
```

### Floating Shadow
```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: YourWidget(),
)
```

### Pressed State
```dart
GestureDetector(
  onTapDown: (_) => setState(() => isPressed = true),
  onTapUp: (_) => setState(() => isPressed = false),
  onTapCancel: () => setState(() => isPressed = false),
  child: AnimatedScale(
    scale: isPressed ? 0.97 : 1.0,
    duration: Duration(milliseconds: 150),
    curve: Curves.easeInOutCubic,
    child: YourWidget(),
  ),
)
```

---

**Last Updated:** October 13, 2025  
**Version:** 1.0  
**Status:** ✅ Ready for Implementation
