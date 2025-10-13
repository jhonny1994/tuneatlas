import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tuneatlas/src/src.dart';

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

    // Listen for audio errors and show snackbar
    ref.listenToAudioErrors(context);

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
          error: (_, __) => Text(
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
            onPressed: () async {
              unawaited(Haptics.toggle());
              await ref.read(themeModeProvider.notifier).toggle();
            },
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
              unawaited(Haptics.light());
              await ref.read(localStationsProvider.notifier).refresh();
            },
            child: AnimationLimiter(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.stations.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.stations.length) {
                    final station = state.stations[index];
                    return StaggeredListItem(
                      index: index,
                      child: StationCard(station: station),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.radio_button_off,
      lottieAsset: 'assets/lottie/radio_empty.json',
      title: 'No stations found',
      message: 'Try searching for stations in other countries',
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return ErrorStateWidget(
      title: 'Failed to load stations',
      error: error,
      onRetry: () => ref.read(localStationsProvider.notifier).refresh(),
    );
  }
}
