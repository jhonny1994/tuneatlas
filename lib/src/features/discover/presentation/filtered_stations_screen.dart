import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

class FilteredStationsScreen extends ConsumerStatefulWidget {
  const FilteredStationsScreen({
    required this.filterType,
    required this.filterValue,
    required this.title,
    super.key,
  });

  final String filterType;
  final String filterValue;
  final String title;

  @override
  ConsumerState<FilteredStationsScreen> createState() =>
      _FilteredStationsScreenState();
}

class _FilteredStationsScreenState
    extends ConsumerState<FilteredStationsScreen> {
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
      unawaited(
        ref
            .read(
              filteredStationsProvider(
                filterType: widget.filterType,
                filterValue: widget.filterValue,
              ).notifier,
            )
            .loadMore(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stationsAsync = ref.watch(
      filteredStationsProvider(
        filterType: widget.filterType,
        filterValue: widget.filterValue,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: stationsAsync.when(
        loading: () => const StationListShimmer(),
        error: (error, stack) => _buildError(context, error),
        data: (state) {
          if (state.isLoading && state.stations.isEmpty) {
            return const StationListShimmer();
          }

          if (state.error != null && state.stations.isEmpty) {
            return _buildError(context, state.error!);
          }

          if (state.stations.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.stations.length + 1,
            itemBuilder: (context, index) {
              if (index < state.stations.length) {
                final station = state.stations[index];
                return StationCard(station: station);
              }

              // Bottom loading/end indicator
              if (state.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return const SizedBox.shrink();
            },
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
            'No stations available for this filter',
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

  Widget _buildError(BuildContext context, Object error) {
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
              onPressed: () {
                ref.invalidate(
                  filteredStationsProvider(
                    filterType: widget.filterType,
                    filterValue: widget.filterValue,
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
