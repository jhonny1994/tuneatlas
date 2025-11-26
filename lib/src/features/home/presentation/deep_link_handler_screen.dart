import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

class DeepLinkHandlerScreen extends ConsumerStatefulWidget {
  const DeepLinkHandlerScreen({
    required this.stationId,
    super.key,
  });

  final String stationId;

  @override
  ConsumerState<DeepLinkHandlerScreen> createState() =>
      _DeepLinkHandlerScreenState();
}

class _DeepLinkHandlerScreenState extends ConsumerState<DeepLinkHandlerScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_handleDeepLink());
  }

  Future<void> _handleDeepLink() async {
    // Wait for initialization if needed
    final initState = ref.read(appInitializationProvider);
    if (initState is! AsyncData) {
      // If app is not initialized, wait a bit or rely on the router redirect to handle initialization flow first
      // But since this screen is likely pushed after initialization (due to router redirect logic), we might be safe.
      // However, deep links might bypass some checks if not careful.
      // The router redirect logic ensures app is initialized before showing any route other than splash/onboarding.
    }

    try {
      final api = ref.read(radioBrowserApiProvider);
      final result = await api.getStationByUuid(widget.stationId);

      if (!mounted) return;

      await result.when(
        success: (station) async {
          // Play station
          await ref.read(audioPlayerProvider.notifier).playStation(station);

          // Navigate to home
          if (mounted) context.go('/home');
        },
        failure: (error) {
          // Show error and go home
          if (mounted) {
            final l10n = S.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.errorPlayingStation}: $error'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            context.go('/home');
          }
        },
      );
    } on Exception catch (e) {
      if (mounted) {
        final l10n = S.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.somethingWentWrong}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
