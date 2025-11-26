import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

class TagsTab extends ConsumerWidget {
  const TagsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);
    final l10n = S.of(context);

    return tagsAsync.when(
      loading: () => const ListTileShimmer(),
      error: (error, stack) => _buildError(context, ref, error),
      data: (tags) {
        if (tags.isEmpty) {
          return _buildEmpty(context);
        }

        // Show only top 100 tags for better performance
        final topTags = tags.take(100).toList();

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConfig.paddingScreen),
            itemCount: topTags.length,
            itemBuilder: (context, index) {
              final tag = topTags[index];

              final tile = Card(
                margin: const EdgeInsets.only(bottom: AppConfig.spacingS),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    child: Icon(
                      Icons.sell,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  title: Text(tag.name),
                  subtitle: Text(l10n.stationsCount(tag.stationCount)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    unawaited(Haptics.light());
                    unawaited(
                      context.push(
                        '/filtered-stations?filterType=tag&filterValue=${tag.name}&title=${Uri.encodeComponent(tag.name)}',
                      ),
                    );
                  },
                ),
              );

              return StaggeredListItem(
                index: index,
                child: tile,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final l10n = S.of(context);
    return ErrorStateWidget(
      title: l10n.errorLoadingStations,
      error: error,
      onRetry: () => ref.invalidate(tagsProvider),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = S.of(context);
    return EmptyStateWidget(
      icon: Icons.sell_outlined,
      title: l10n.noTagsTitle,
      message: l10n.noData,
    );
  }
}
