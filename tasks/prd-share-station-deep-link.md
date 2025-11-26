# PRD: Share Station with Deep Linking

## 1. Introduction
This feature enables users to share radio stations from the TuneAtlas app with others. When a user shares a station, the system will generate a deep link. Clicking this link on a device with TuneAtlas installed will open the app and immediately play the shared station.

## 2. Goals
*   Increase user engagement by facilitating content sharing.
*   Provide a seamless "click-to-play" experience for shared content.
*   Implement deep linking infrastructure to support future external linking needs.

## 3. User Stories
*   **Story 1:** As a listener, I want to share the current station I'm enjoying with a friend via WhatsApp/SMS, so they can listen to it too.
*   **Story 2:** As a recipient of a shared link, I want clicking the link to open TuneAtlas and automatically start playing the specific station, without searching for it manually.

## 4. Functional Requirements

### 4.1. Share Action
1.  The "Share" option in the `StationCard` "More Options" menu (bottom sheet) must be functional.
2.  Tapping "Share" must trigger the native system share sheet (iOS/Android).
3.  The shared content must include:
    *   A promotional message (e.g., "Listen to [Station Name] on TuneAtlas!").
    *   A deep link URL (e.g., `tuneatlas://station/[station_uuid]`).

### 4.2. Deep Link Handling
1.  The app must register a custom URL scheme (e.g., `tuneatlas://`) or Universal Link to handle incoming traffic.
2.  **Route Configuration:** `GoRouter` must be configured to recognize the `/station/:id` path.
3.  **Navigation Logic:**
    *   **Cold Start:** If the app is closed, clicking the link launches the app, initializes necessary providers, and plays the station.
    *   **Warm Start:** If the app is in the background, clicking the link brings it to the foreground and plays the station.
4.  **Playback:** Upon processing the deep link, the app must:
    *   Fetch the station details using the UUID (if not fully contained in the link).
    *   Immediately trigger the `AudioPlayerService` to play the station.

## 5. Non-Goals
*   Web playback (the link will not play in a browser; it requires the app).
*   Social media preview cards (Open Graph tags) - this requires a web landing page which is out of scope.
*   Analytics tracking for share events.

## 6. Technical Considerations

### 6.1. Dependencies
*   **`share_plus`**: For invoking the native share sheet.
*   **`go_router`**: Already in use; needs configuration for deep link routes.

### 6.2. Platform Configuration
*   **Android (`AndroidManifest.xml`):** Add `<intent-filter>` for the custom scheme/host.
*   **iOS (`Info.plist`):** Add `CFBundleURLTypes` for the custom scheme.

### 6.3. Architecture Integration
*   The `StationCard` widget currently contains the `TODO` for sharing.
*   Deep link navigation logic should likely reside in the `router.dart` configuration or a dedicated `DeepLinkService` that interacts with `GoRouter`.
*   Since `Station` objects are complex, the deep link will likely only carry the `stationUuid`. The app needs a way to fetch the full `Station` object by ID if it's not already in the local cache (requires an API endpoint or lookup method). *Assumption: The `RadioBrowserApi` has a method to fetch a station by UUID.*

## 7. Success Metrics
*   Successful launch of the system share sheet when "Share" is tapped.
*   App successfully opens and plays the correct station when a deep link is clicked.
