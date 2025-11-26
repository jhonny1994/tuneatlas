# Tasks: Share Station with Deep Linking

## Relevant Files

- `lib/src/features/home/presentation/widgets/station_card.dart` - Contains the "Share" button and UI logic.
- `lib/src/core/routing/router.dart` - Needs configuration to handle the `/station/:id` deep link route.
- `lib/src/core/api/radio_browser_api.dart` - May need a method to fetch a single station by UUID.
- `android/app/src/main/AndroidManifest.xml` - Android configuration for deep links.
- `ios/Runner/Info.plist` - iOS configuration for deep links.
- `pubspec.yaml` - To add the `share_plus` dependency.

### Notes

- Unit tests should typically be placed alongside the code files they are testing.
- Use `flutter test` to run tests.

## Instructions for Completing Tasks

**IMPORTANT:** As you complete each task, you must check it off in this markdown file by changing `- [ ]` to `- [x]`. This helps track progress and ensures you don't skip any steps.

Example:
- `- [ ] 1.1 Read file` → `- [x] 1.1 Read file` (after completing)

Update the file after completing each sub-task, not just after completing an entire parent task.

## Tasks

- [x] 0.0 Create feature branch
  - [x] 0.1 Create and checkout a new branch for this feature (e.g., `git checkout -b feature/share-station-deep-link`)

- [x] 1.0 Add Dependencies & Platform Configuration
  - [x] 1.1 Add `share_plus` to `pubspec.yaml` and run `flutter pub get`.
  - [x] 1.2 Configure Android `AndroidManifest.xml`: Add `<intent-filter>` inside the main `<activity>` to handle `android:scheme="tuneatlas"` and `android:host="station"`.
  - [x] 1.3 Configure iOS `Info.plist`: Add `CFBundleURLTypes` array with `CFBundleURLSchemes` containing `tuneatlas`.

- [x] 2.0 Implement Deep Link Routing Logic
  - [x] 2.1 Verify `RadioBrowserApi` has a method to fetch a station by UUID. If not, add `getStationByUuid(String uuid)` to `RadioBrowserApi` and its provider.
  - [x] 2.2 Update `router.dart`: Add a `GoRoute` for path `/station/:stationId`.
  - [x] 2.3 In the route builder for `/station/:stationId`, implement logic to:
    - Extract `stationId`.
    - Show a loading indicator or a specific "Deep Link Handler" screen.
    - Call `RadioBrowserApi` to fetch the station.
    - On success: Call `AudioPlayerService.playStation(station)` and redirect to `/home` (or open the player view).
    - On failure: Show an error snackbar/dialog and redirect to `/home`.

- [x] 3.0 Implement Share Functionality in UI
  - [x] 3.1 Open `lib/src/features/home/presentation/widgets/station_card.dart`.
  - [x] 3.2 Locate the `_showStationOptions` method and the `TODO: Implement share functionality`.
  - [x] 3.3 Implement `_shareStation(BuildContext context, Station station)` method.
    - Construct the deep link: `tuneatlas://station/${station.stationUuid}`.
    - Construct the message: `"Listen to ${station.name} on TuneAtlas! $deepLink"`.
  - [x] 3.4 Call `Share.share(message)` inside the share action callback.

  - [x] 4.0 Verify & Test
  - [x] 4.1 Run the app on Android/iOS emulator.
  - [x] 4.2 Tap "Share" on a station and verify the system share sheet appears with the correct text.
  - [x] 4.3 Test Deep Link (Android): Run `adb shell am start -W -a android.intent.action.VIEW -d "tuneatlas://station/[VALID_UUID]" com.carbodex.tuneatlas`. Verify app opens and plays.
  - [x] 4.4 Test Deep Link (iOS): Use Simulator command `xcrun simctl openurl booted "tuneatlas://station/[VALID_UUID]"`. Verify app opens and plays.