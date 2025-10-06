import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorAtlasKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellAtlas',
);
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSearch',
);
final _shellNavigatorLibraryKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellLibrary',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAtlasKey,
            routes: [
              GoRoute(
                path: '/atlas',
                parentNavigatorKey: _shellNavigatorAtlasKey,
                builder: (context, state) => const AtlasScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: '/search',
                parentNavigatorKey: _shellNavigatorSearchKey,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorLibraryKey,
            routes: [
              GoRoute(
                path: '/library',
                parentNavigatorKey: _shellNavigatorLibraryKey,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                parentNavigatorKey: _shellNavigatorProfileKey,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
