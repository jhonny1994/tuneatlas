import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/core/core.dart';
import 'package:tuneatlas/src/features/home/data/local_stations_provider.dart';
import 'package:tuneatlas/src/features/home/presentation/widgets/station_card.dart';
import 'package:tuneatlas/src/features/home/presentation/widgets/station_card_shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    const thresholdPx = 200.0;
    if (_scrollController.position.pixels + thresholdPx >=
        _scrollController.position.maxScrollExtent) {
      // Fetch next page if possible
      unawaited(ref.read(localStationsProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(localStationsProvider);
    final userCountryAsync = ref.watch(userCountryProvider);

    return Scaffold(
      appBar: AppBar(
        title: userCountryAsync.when(
          data: (countryCode) => Text(
            'Stations in $countryCode',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          loading: () => Text(
            'TuneAtlas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          error: (_, _) => Text(
            'TuneAtlas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.brightness_6_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: stationsAsync.when(
        loading: () => const StationListShimmer(),
        error: (error, stack) => _buildError(context, ref, error),
        data: (state) {
          if (state.isLoading && state.stations.isEmpty) {
            return const StationListShimmer();
          }

          if (state.error != null && state.stations.isEmpty) {
            return _buildError(context, ref, state.error!);
          }

          if (state.stations.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(localStationsProvider.notifier).refresh();
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.stations.length + 1,
              itemBuilder: (context, index) {
                if (index < state.stations.length) {
                  final station = state.stations[index];
                  return StationCard(
                    station: station,
                    onTap: () {
                      // TODO: Start playback
                    },
                  );
                }
                // Show bottom loader if loading more
                if (state.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.radio_button_off,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No stations found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for stations in other countries',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load stations',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(localStationsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
