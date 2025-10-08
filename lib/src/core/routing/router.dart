import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';
import 'package:tuneatlas/src/features/discover/presentation/discover_screen.dart';
import 'package:tuneatlas/src/features/discover/presentation/filtered_stations_screen.dart';
import 'package:tuneatlas/src/features/home/presentation/home_screen.dart';
import 'package:tuneatlas/src/features/library/presentation/library_screen.dart';
import 'package:tuneatlas/src/features/onboarding/data/onboarding_provider.dart';
import 'package:tuneatlas/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:tuneatlas/src/features/onboarding/presentation/splash_screen.dart';
import 'package:tuneatlas/src/features/player/presentation/full_player_screen.dart';
import 'package:tuneatlas/src/features/search/presentation/search_screen.dart';

part 'router.g.dart';

/// Root navigation with bottom navigation bar
class RootScreen extends StatefulWidget {
  const RootScreen({required this.child, super.key});

  final Widget child;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
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
      // Splash screen (initialization)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding screen (first launch)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) => RootScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
        ],
      ),

      // Player screen (full screen, no bottom nav)
      GoRoute(
        path: '/player',
        builder: (context, state) => const FullPlayerScreen(),
      ),

      // Filtered stations screen (from discover)
      GoRoute(
        path: '/filtered-stations',
        builder: (context, state) {
          final filterType = state.uri.queryParameters['filterType'] ?? '';
          final filterValue = state.uri.queryParameters['filterValue'] ?? '';
          final title = state.uri.queryParameters['title'] ?? 'Stations';

          return FilteredStationsScreen(
            filterType: filterType,
            filterValue: filterValue,
            title: title,
          );
        },
      ),
    ],
  );
}
