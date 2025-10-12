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

### Audio Playback Architecture
- **Service Layer**: `AudioPlayerService` singleton wraps `just_audio` + `audio_service` for background playback
- **Audio Handler**: `RadioAudioHandler` extends `BaseAudioHandler` for system media controls
- **State Management**: `AudioPlayer` provider exposes reactive `Stream<AudioState>` combining all audio streams (position, playing status, loading, errors)
- **Station Playback**: Call `audioPlayerProvider.playStation(station)` - never manipulate streams directly
- **Error Handling**: 
  - Built-in 15-20 second timeouts prevent infinite loading
  - Use `ref.listenToAudioErrors(context)` extension in screens to show error snackbars
  - Mini player automatically displays error banner with retry button

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
- Always prefer extensions/utilities over duplicating code across screens

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