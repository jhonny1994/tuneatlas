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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.library,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
          IconButton(
            icon: Icon(
              Icons.brightness_6_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              unawaited(Haptics.toggle());
              await ref.read(themeModeProvider.notifier).toggle();
            },
          ),
          const LanguageButton(),
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
                padding: const EdgeInsets.all(AppConfig.paddingScreen),
                itemCount: favorites.length,
                cacheExtent: 500, // Pre-render off-screen items
                addAutomaticKeepAlives: false, // Don't keep state unnecessarily
                itemBuilder: (context, index) {
                  final station = favorites[index];
                  return StaggeredListItem(
                    index: index,
                    child: StationCard(
                      key: ValueKey(station.stationUuid),
                      station: station,
                    ),
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
    final l10n = AppLocalizations.of(context)!;
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: l10n.noFavoritesTitle,
      message: l10n.noFavoritesMessage,
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorStateWidget(
      title: l10n.errorLoadingStations,
      error: error,
      onRetry: () => ref.read(favoritesProvider.notifier).refresh(),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    unawaited(
      showDialog(
        context: context,
        builder: (context) {
          final favoritesAsync = ref.watch(favoritesProvider);
          final count = favoritesAsync.maybeWhen(
            data: (favorites) => favorites.length,
            orElse: () => 0,
          );

          return AlertDialog(
            title: Text(l10n.clearFavoritesConfirmTitle),
            content: Text(
              l10n.clearFavoritesConfirmMessage(count),
            ),
            actions: [
              FilledButton.tonal(
                onPressed: () {
                  unawaited(Haptics.light());
                  Navigator.of(context).pop();
                },
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () async {
                  unawaited(Haptics.medium());
                  await FavoritesService.instance.clearAll();
                  await ref.read(favoritesProvider.notifier).refresh();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: Text(l10n.clear),
              ),
            ],
          );
        },
      ),
    );
  }
}
