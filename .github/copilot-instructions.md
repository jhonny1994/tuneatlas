# TuneAtlas - AI Coding Agent Instructions

## Project Overview
TuneAtlas is a Flutter-based global radio tuner app that streams live radio stations via the Radio Browser API. The app supports cross-platform deployment (Android, iOS) with background audio playback capabilities.

## Architecture & Key Patterns

### Feature-Based Structure
- **Core layer** (`lib/src/core/`): Shared infrastructure (API client, routing, database, config, models)
- **Features layer** (`lib/src/features/`): Domain-specific modules (home, discover, library, player, search, onboarding)
- Each feature follows data/presentation separation: `data/` contains providers/services, `presentation/` contains UI

### State Management: Riverpod + Code Generation
- **Primary pattern**: Use `@riverpod` annotation with `riverpod_generator` (NOT manual `Provider` classes)
- **Stateful providers**: Annotate with `@Riverpod(keepAlive: true)` for singleton-like behavior (e.g., `audio_provider.dart`, `favorites_provider.dart`)
- **Generated files**: Every `@riverpod` provider requires `part 'filename.g.dart'` directive
- **Ref access**: Use `ref.watch()` for reactive dependencies, `ref.read()` for one-time reads

### Data Models: Freezed + JSON Serialization
- All models use `@freezed` annotation with `freezed_annotation`
- JSON models require both `.freezed.dart` and `.g.dart` part files (e.g., `station.dart`)
- Use `Result<T>` wrapper (`lib/src/core/models/result.dart`) for API responses: `Result.success(data)` or `Result.failure(error)`

### Code Generation Workflow
Run code generation after creating/modifying annotated files:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Critical Components

### Radio Browser API Integration
- **Server Discovery** (`server_discovery.dart`): DNS lookup + health checks to find working API servers at startup
- **ApiClient** (`api_client.dart`): Dio-based HTTP client with dynamic base URL updated after discovery
- **Initialization Flow**: `AppInitialization` provider (`app_initialization_provider.dart`) orchestrates discovery → API setup → app ready
- **Error Handling**: All API methods return `Result<T>` for type-safe error propagation

### Network State Management
- **Network Monitoring**: `NetworkMonitor` provider streams `NetworkStatus` (online/offline) using `connectivity_plus`
- **Offline Indicator**: `OfflineIndicator` widget shows persistent banner when connection is lost
- **Auto-Reconnect**: `NetworkReconnectHandler` automatically resumes playback when network returns
  - Tracks last playing station before disconnect
  - Waits 2 seconds for network stability before reconnecting
  - Validates user hasn't changed stations before reconnecting
- **UI Integration**: Offline indicator integrated into `RootScreen` above main content

### Audio Playback Architecture
- **Service Layer**: `AudioPlayerService` singleton wraps `just_audio` + `audio_service` for background playback
- **Audio Handler**: `RadioAudioHandler` extends `BaseAudioHandler` for system media controls
- **State Management**: `AudioPlayer` provider exposes reactive `Stream<AudioState>` combining all audio streams (position, playing status, loading, errors)
- **Station Playback**: Call `audioPlayerProvider.playStation(station)` - never manipulate streams directly
- **Error Handling** (production-grade implementation):
  - **Dual Timeouts**: 15s in `audio_handler.dart`, 20s in `audio_player_service.dart` prevent infinite loading
  - **State Consistency**: Always clear loading state on error, set playing=false, stopped=true
  - **Station Retention**: Keep `_currentStation` on error to enable retry without re-selection
  - **Categorized Errors**: TimeoutException, 404/403, network errors, format errors → user-friendly messages
  - **Consolidated Handling**: `_handleError()` method in handler ensures all error paths set consistent state
  - **UI Integration**: Use `ref.listenToAudioErrors(context)` extension in screens to show error snackbars
  - **Mini Player**: Automatically displays error banner with retry button when errors occur
  - **Recovery**: Error clearing on successful playback attempts, no stale error state

### Persistence Strategy
- **Favorites**: Sembast NoSQL database (`database_service.dart`, `favorites_service.dart`) stores station objects in `favorites` store
- **Settings/Preferences**: SharedPreferences for simple key-value (theme mode, onboarding status, country cache)
- **Provider Override**: `sharedPreferencesProvider` MUST be overridden in `ProviderScope` at app startup (see `main.dart`)

### Routing & Navigation
- **GoRouter** configuration in `router.dart` with `@riverpod` annotation
- **Redirect Logic**: Checks initialization state → onboarding completion → home
- **Shell Route**: `RootScreen` provides bottom navigation + persistent mini player across routes
- Navigation paths: `/home`, `/discover`, `/library`, `/search`, `/onboarding`

## Development Conventions

### Linting & Formatting
- Uses `very_good_analysis` with custom overrides (see `analysis_options.yaml`)
- Enables `custom_lint` with `riverpod_lint` for provider-specific rules

### File Organization
- Always use barrel exports (`feature.dart`, `core.dart`, `src.dart`) for clean imports
- Keep widgets in `presentation/widgets/` subdirectories
- Place provider logic in `data/` folders with clear `_provider.dart` suffix

### UI Patterns
- Screens extend `ConsumerWidget` or `ConsumerStatefulWidget` for Riverpod integration
- Use `ref.watch(provider)` to rebuild on state changes
- Wrap async providers with `.when()` for loading/error states
- Shimmer placeholders configured via `AppConfig.shimmerDuration`
- **Audio Error Notifications**: Add `ref.listenToAudioErrors(context)` in build method of screens that play audio

### Configuration Management
- **All constants** live in `AppConfig` class (`app_config.dart`) - no magic numbers
- Theme configuration in `AppTheme` with `lightTheme()` and `darkTheme()` factories
- Pagination, caching, timeouts all defined centrally

### Reusable Utilities
- **Audio Error Listener**: `AudioErrorListener` extension on `WidgetRef` provides `listenToAudioErrors(context)` for consistent error handling
- **Haptic Feedback**: `Haptics` utility class provides consistent tactile feedback (light/selection/medium/heavy/vibrate)
- Always prefer extensions/utilities over duplicating code across screens

### UI/UX Enhancements
- **Haptic Feedback**: All interactive elements provide tactile feedback using `Haptics` utility
  - Station taps: `Haptics.light()`
  - Favorite toggles: `Haptics.toggle()`
  - Theme switches: `Haptics.toggle()`
  - Pull-to-refresh: `Haptics.light()`
  - Onboarding navigation: `Haptics.light()`
  - Dialog buttons: `Haptics.light()` (cancel), `Haptics.medium()` (destructive actions)
  - Feature flag: `AppConfig.enableHaptics` to disable globally
- **Micro-Interactions**: Cards use `AnimatedScale` with press state tracking for tactile feel
  - Press scale: `AppConfig.pressedScale` (0.97)
  - Animation duration: `AppConfig.fastAnimation` (150ms)
  - Curve: `AppConfig.defaultCurve` (easeInOutCubic)
- **Page Transitions**: Custom transitions via `AppPageTransitions` utility
  - Fade: For splash/initialization screens
  - Slide Right: For hierarchical forward navigation (onboarding)
  - Scale Fade: For bottom navigation peer transitions (200ms)
  - Shared Axis: For hierarchical navigation with depth (filtered screens)
  - All transitions respect Material Design motion principles
  - **Accessibility**: All transitions check `MediaQuery.disableAnimationsOf()` to respect reduced motion preferences
- **Staggered Animations**: Lists use `StaggeredListItem` reusable widget for sequential reveals
  - First 20 items animated (AppConfig.maxStaggerItems)
  - 300ms duration with 50ms stagger delay (AppConfig.staggerOffset)
  - Slide (50px vertical) + fade combination
  - Applied to: Home, Search, Library, Discover tabs (Countries, Languages, Tags)
  - **Accessibility**: Respects `MediaQuery.disableAnimationsOf()` for reduced motion
  - **DRY**: Centralized in `StaggeredListItem` widget to eliminate code duplication
- **Error States**: Consistent error UI via `ErrorStateWidget` reusable widget
  - Standardized icon, title, message, and retry button
  - Built-in haptic feedback on retry action
  - Used across: Home, Search, Library, Discover tabs, Filtered Stations
  - **DRY**: Eliminated ~150 lines of duplicated error handling code
- **Empty States**: Consistent empty UI via `EmptyStateWidget` reusable widget
  - Standardized icon, title, and message layout
  - Optional action button support
  - Used across: Home, Search, Library, Discover tabs (Countries, Languages, Tags), Filtered Stations
  - **DRY**: Eliminated ~180 lines of duplicated empty state code
  - **Consistency**: All empty states now follow the same visual pattern
- **Loading States**: Context-specific shimmer variants
  - `StationCardShimmer`: For station lists
  - `ListTileShimmer`: For countries/languages/tags tabs
  - `StationListShimmer`: Wrapper for multiple shimmer cards

### Reusable Utilities
- **Haptics**: `Haptics` utility class provides consistent tactile feedback (light/selection/medium/heavy/vibrate)
- **Audio Error Listener**: `AudioErrorListener` extension on `WidgetRef` provides `listenToAudioErrors(context)` for consistent error handling
- **Staggered Animations**: `StaggeredListItem` widget for consistent list reveals with reduced motion support
- **Error States**: `ErrorStateWidget` for consistent error UI with retry button and haptic feedback
- **Empty States**: `EmptyStateWidget` for consistent empty UI with icon, title, and message
- Always prefer extensions/utilities over duplicating code across screens

### UI Constants (AppConfig)
All UI constants are centralized in `AppConfig` for consistent design:
- **Border Radius**: `radiusCard` (16), `radiusInput` (12), `radiusImage` (8), `radiusChip` (4)
- **Spacing**: `spacingXXL` (48), `spacingXL` (32), `spacingL` (24), `spacingM` (16), `spacingS` (8), `spacingXS` (4)
- **Padding**: `paddingScreen` (16), `paddingContent` (32), `paddingCard` (12)
- **Icons**: `iconSizeLarge` (80) for empty/error states
- **Buttons**: `buttonHeight` (48) for standard buttons
- Never hardcode dimensions - always use AppConfig constants

## Common Tasks

### Adding a New Feature
1. Create `lib/src/features/new_feature/` directory
2. Add `data/` (providers, models) and `presentation/` (screens, widgets) subdirectories
3. Create barrel file: `new_feature.dart` exporting `data/data.dart` and `presentation/presentation.dart`
4. Add export to `lib/src/features/features.dart`
5. Run `dart run build_runner build --delete-conflicting-outputs`

### Creating a Provider
```dart
@Riverpod(keepAlive: true) // Add for singletons
class MyData extends _$MyData {
  @override
  FutureOr<DataType> build() {
    // Initialization logic
  }
  
  // Methods to mutate state
  Future<void> updateData() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Update logic
    });
  }
}
```

### Testing Commands
- Analyze: `flutter analyze`

## External Dependencies
- **Audio**: `just_audio` (streaming), `audio_service` (background playback)
- **Network**: `dio` (HTTP), `connectivity_plus` (network status)
- **Storage**: `sembast` (local database), `shared_preferences` (simple persistence)
- **UI**: `cached_network_image` (image loading), `shimmer` (loading states), `google_fonts`
- **Dev Tools**: `device_preview` (responsive testing, Windows debug only)

## Anti-Patterns to Avoid
- ❌ Don't create manual `Provider` instances - use `@riverpod` generator
- ❌ Don't mutate state directly - always use `state =` in Notifier classes
- ❌ Don't bypass `Result<T>` wrapper for API responses
- ❌ Don't hardcode URLs, timeouts, or dimensions - use `AppConfig`
- ❌ Avoid direct `just_audio` player access - use `AudioPlayerService` singleton
- ❌ Don't forget to run code generation after modifying annotated files
- ❌ DRY (Don't Repeat Yourself) - extract common logic into reusable functions or widgets