import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tuneatlas/src/src.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Library',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Show clear all button if there are favorites
          favoritesAsync.whenOrNull(
                data: (favorites) => favorites.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          unawaited(Haptics.light());
                          _showClearDialog(context, ref);
                        },
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: favoritesAsync.when(
        loading: () => const StationListShimmer(),
        error: (error, stack) => _buildError(context, ref, error),
        data: (favorites) {
          if (favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              unawaited(Haptics.light());
              await ref.read(favoritesProvider.notifier).refresh();
            },
            child: AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final station = favorites[index];
                  return StaggeredListItem(
                    index: index,
                    child: StationCard(station: station),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No favorites yet',
      message: 'Add stations to your favorites by tapping the heart icon',
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return ErrorStateWidget(
      title: 'Failed to load favorites',
      error: error,
      onRetry: () => ref.read(favoritesProvider.notifier).refresh(),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    unawaited(
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear all favorites?'),
          content: const Text(
            'This will remove all stations from your library. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                unawaited(Haptics.light());
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                unawaited(Haptics.medium());
                await FavoritesService.instance.clearAll();
                await ref.read(favoritesProvider.notifier).refresh();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Clear',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
