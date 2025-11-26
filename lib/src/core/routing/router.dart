import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/features/home/presentation/deep_link_handler_screen.dart';
import 'package:tuneatlas/src/src.dart';

part 'router.g.dart';

/// Root navigation with bottom navigation bar and mini player
class RootScreen extends ConsumerWidget {
  const RootScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final l10n = S.of(context);

    // Determine selected index based on current route
    var selectedIndex = 0;
    if (location.startsWith('/discover')) {
      selectedIndex = 1;
    } else if (location.startsWith('/library')) {
      selectedIndex = 2;
    } else if (location.startsWith('/search')) {
      selectedIndex = 3;
    }

    return Scaffold(
      body: Column(
        children: [
          // Offline indicator at the top
          const OfflineIndicator(),
          // Main content
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini player (shown when audio is playing)
          const MiniPlayer(),

          // Bottom navigation bar
          NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                case 1:
                  context.go('/discover');
                case 2:
                  context.go('/library');
                case 3:
                  context.go('/search');
              }
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore),
                label: l10n.discover,
              ),
              NavigationDestination(
                icon: const Icon(Icons.library_music_outlined),
                selectedIcon: const Icon(Icons.library_music),
                label: l10n.library,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search_outlined),
                selectedIcon: const Icon(Icons.search),
                label: l10n.search,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@riverpod
GoRouter router(Ref ref) {
  // Watch both initialization and onboarding state
  final initState = ref.watch(appInitializationProvider);
  final onboardingCompleted = ref.watch(onboardingStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/splash';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // Check initialization state
      return initState.maybeWhen(
        success: () {
          // Initialization complete

          // If not on onboarding screen and onboarding not completed
          if (!onboardingCompleted && !isOnboarding) {
            return '/onboarding';
          }

          // If on onboarding screen but already completed
          if (isOnboarding && onboardingCompleted) {
            return '/home';
          }

          // If on splash and onboarding completed, go to home
          if (isSplash && onboardingCompleted) {
            return '/home';
          }

          return null; // No redirect needed
        },
        orElse: () {
          // Stay on splash during loading or error
          if (!isSplash) return '/splash';
          return null;
        },
      );
    },
    routes: [
      // Splash screen (initialization) - Fade in
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
          child: const SplashScreen(),
          state: state,
        ),
      ),

      // Onboarding screen (first launch) - Slide from right
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Deep link for station
      GoRoute(
        path: '/station/:stationId',
        builder: (context, state) {
          final stationId = state.pathParameters['stationId']!;
          return DeepLinkHandlerScreen(stationId: stationId);
        },
      ),

      // Main app routes with bottom navigation - Scale fade for smooth peer transitions
      ShellRoute(
        builder: (context, state, child) => RootScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                AppPageTransitions.scaleFadeTransition(
              child: const HomeScreen(),
              state: state,
              duration: const Duration(milliseconds: 200),
            ),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder: (context, state) =>
                AppPageTransitions.scaleFadeTransition(
              child: const DiscoverScreen(),
              state: state,
              duration: const Duration(milliseconds: 200),
            ),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) =>
                AppPageTransitions.scaleFadeTransition(
              child: const LibraryScreen(),
              state: state,
              duration: const Duration(milliseconds: 200),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) =>
                AppPageTransitions.scaleFadeTransition(
              child: const SearchScreen(),
              state: state,
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ],
      ),

      // Filtered stations screen (from discover) - Shared axis for hierarchy
      GoRoute(
        path: '/filtered-stations',
        pageBuilder: (context, state) {
          final l10n = S.of(context);
          final filterType = state.uri.queryParameters['filterType'] ?? '';
          final filterValue = state.uri.queryParameters['filterValue'] ?? '';
          final title = state.uri.queryParameters['title'] ?? l10n.stations;

          return AppPageTransitions.sharedAxisTransition(
            child: FilteredStationsScreen(
              filterType: filterType,
              filterValue: filterValue,
              title: title,
            ),
            state: state,
          );
        },
      ),
    ],
  );
}
