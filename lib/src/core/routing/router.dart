import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Import screens
import 'package:tuneatlas/src/features/discover/presentation/discover_screen.dart';
import 'package:tuneatlas/src/features/home/presentation/home_screen.dart';
import 'package:tuneatlas/src/features/library/presentation/library_screen.dart';
import 'package:tuneatlas/src/features/player/presentation/full_player_screen.dart';
import 'package:tuneatlas/src/features/search/presentation/search_screen.dart';

part 'router.g.dart';

/// GoRouter configuration
/// This will generate `routerProvider` automatically
@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/home',

    routes: [
      // Bottom navigation shell - wraps all tab screens
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),

          // Branch 2: Discover
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                name: 'discover',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DiscoverScreen(),
                ),
              ),
            ],
          ),

          // Branch 3: Library
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: 'library',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: LibraryScreen(),
                ),
              ),
            ],
          ),

          // Branch 4: Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SearchScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes (not in bottom nav)
      GoRoute(
        path: '/player',
        name: 'player',
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: FullPlayerScreen(),
        ),
      ),
    ],
  );
}

/// Main scaffold with bottom navigation bar
class MainNavigationScaffold extends StatelessWidget {
  const MainNavigationScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
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
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
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
