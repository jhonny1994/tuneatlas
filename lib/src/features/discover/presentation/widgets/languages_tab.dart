import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

class LanguagesTab extends ConsumerWidget {
  const LanguagesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languagesAsync = ref.watch(languagesProvider);
    final l10n = S.of(context);

    return languagesAsync.when(
      loading: () => const ListTileShimmer(),
      error: (error, stack) => _buildError(context, ref, error),
      data: (languages) {
        if (languages.isEmpty) {
          return _buildEmpty(context);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConfig.paddingScreen),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];

              final tile = Card(
                margin: const EdgeInsets.only(bottom: AppConfig.spacingS),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(language.name),
                  subtitle: Text(l10n.stationsCount(language.stationCount)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    unawaited(Haptics.light());
                    unawaited(
                      context.push(
                        '/filtered-stations?filterType=language&filterValue=${language.name}&title=${Uri.encodeComponent(language.name)}',
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
      onRetry: () => ref.invalidate(languagesProvider),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = S.of(context);
    return EmptyStateWidget(
      icon: Icons.language_outlined,
      title: l10n.noLanguagesTitle,
      message: l10n.noData,
    );
  }
}
