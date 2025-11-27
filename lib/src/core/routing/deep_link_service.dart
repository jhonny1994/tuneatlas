import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'deep_link_service.g.dart';

@Riverpod(keepAlive: true)
class DeepLinkService extends _$DeepLinkService {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  FutureOr<void> build() async {
    final appLinks = AppLinks();

    // Handle the initial link (cold start)
    try {
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } on Exception catch (e) {
      debugPrint('DeepLinkService: Error getting initial link: $e');
    }

    // Listen for subsequent links
    _linkSubscription = appLinks.uriLinkStream.listen(
      _handleLink,
      onError: (Object err) {
        debugPrint('DeepLinkService: Error listening to links: $err');
      },
    );

    ref.onDispose(() {
      if (_linkSubscription != null) {
        unawaited(_linkSubscription!.cancel());
      }
    });
  }

  void _handleLink(Uri uri) {
    String? targetPath;

    // Check if it's our GitHub Pages URL
    // https://dmar.site/tuneatlas/station/UUID
    if (uri.host == 'dmar.site' && uri.path.contains('/tuneatlas/station/')) {
      final segments = uri.pathSegments;
      // pathSegments for /tuneatlas/station/UUID -> ['tuneatlas', 'station', 'UUID']
      final stationIndex = segments.indexOf('station');
      if (stationIndex != -1 && stationIndex + 1 < segments.length) {
        final stationId = segments[stationIndex + 1];
        targetPath = '/station/$stationId';
      }
    }
    // Fallback for custom scheme if still supported
    // tuneatlas://station/UUID
    else if (uri.scheme == 'tuneatlas') {
      // Case 1: tuneatlas://station/UUID (Host is 'station', Path is '/UUID')
      if (uri.host == 'station') {
        final stationId = uri.path.replaceAll('/', ''); // Remove leading slash
        if (stationId.isNotEmpty) {
          targetPath = '/station/$stationId';
        }
      }

      if (targetPath == null) {
        final path = uri.path;
        if (path.startsWith('/station/')) {
          final stationId = path.replaceFirst('/station/', '');
          if (stationId.isNotEmpty) {
            targetPath = '/station/$stationId';
          }
        } else if (path.contains('/station/')) {
          // Handle case with host: tuneatlas://tuneatlas.com/station/UUID
          final segments = uri.pathSegments;
          final stationIndex = segments.indexOf('station');
          if (stationIndex != -1 && stationIndex + 1 < segments.length) {
            final stationId = segments[stationIndex + 1];
            targetPath = '/station/$stationId';
          }
        }
      }
    }

    if (targetPath != null) {
      final onboardingCompleted = ref.read(onboardingStateProvider);
      if (onboardingCompleted) {
        ref.read(routerProvider).go(targetPath);
      } else {
        // Store for later
        ref.read(pendingDeepLinkProvider.notifier).set(targetPath);
      }
    }
  }
}
