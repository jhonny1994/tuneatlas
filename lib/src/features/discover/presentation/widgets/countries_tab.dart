import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

class CountriesTab extends ConsumerWidget {
  const CountriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return countriesAsync.when(
      loading: () => const ListTileShimmer(),
      error: (error, stack) => _buildError(context, ref, error),
      data: (countries) {
        if (countries.isEmpty) {
          return _buildEmpty(context);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];

              final tile = Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      country.name.isNotEmpty
                          ? country.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(country.name),
                  subtitle: Text('${country.stationCount} stations'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    unawaited(Haptics.light());
                    unawaited(
                      context.push(
                        '/filtered-stations?filterType=country&filterValue=${country.code}&title=${Uri.encodeComponent(country.name)}',
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
      title: 'Failed to load countries',
      error: error,
      onRetry: () => ref.invalidate(countriesProvider),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.public_off,
      title: 'No countries available',
      message: 'Unable to load countries at this time',
    );
  }
}
