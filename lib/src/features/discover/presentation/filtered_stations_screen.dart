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

    // Listen for audio errors and show snackbar
    ref.listenToAudioErrors(context);

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
    return const EmptyStateWidget(
      icon: Icons.radio_button_off,
      title: 'No stations found',
      message: 'No stations available for this filter',
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return ErrorStateWidget(
      title: 'Failed to load stations',
      error: error,
      onRetry: () {
        ref.invalidate(
          filteredStationsProvider(
            filterType: widget.filterType,
            filterValue: widget.filterValue,
          ),
        );
      },
    );
  }
}
