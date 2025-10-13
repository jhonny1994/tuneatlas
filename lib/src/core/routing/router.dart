import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'router.g.dart';

/// Root navigation with bottom navigation bar and mini player
class RootScreen extends ConsumerWidget {
  const RootScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

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
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music),
                label: 'Library',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'Search',
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
        pageBuilder: (context, state) =>
            AppPageTransitions.slideRightTransition(
          child: const OnboardingScreen(),
          state: state,
        ),
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
          final filterType = state.uri.queryParameters['filterType'] ?? '';
          final filterValue = state.uri.queryParameters['filterValue'] ?? '';
          final title = state.uri.queryParameters['title'] ?? 'Stations';

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
