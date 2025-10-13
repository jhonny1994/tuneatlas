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

    return languagesAsync.when(
      loading: () => const ListTileShimmer(),
      error: (error, stack) => _buildError(context, ref, error),
      data: (languages) {
        if (languages.isEmpty) {
          return _buildEmpty(context);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];

              final tile = Card(
                margin: const EdgeInsets.only(bottom: 8),
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
                  subtitle: Text('${language.stationCount} stations'),
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
    return ErrorStateWidget(
      title: 'Failed to load languages',
      error: error,
      onRetry: () => ref.invalidate(languagesProvider),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.language_outlined,
      title: 'No languages available',
      message: 'Unable to load languages at this time',
    );
  }
}
