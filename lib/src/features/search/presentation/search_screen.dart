import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tuneatlas/src/src.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels + AppConfig.scrollThresholdPx >=
        _scrollController.position.maxScrollExtent) {
      unawaited(ref.read(searchProvider.notifier).loadMore());
    }
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer (wait 500ms after user stops typing)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        unawaited(ref.read(searchProvider.notifier).search(query));
      } else {
        ref.read(searchProvider.notifier).clear();
      }
    });
  }

  void _onClearSearch() {
    unawaited(Haptics.light());
    _searchController.clear();
    ref.read(searchProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final l10n = S.of(context);

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
          l10n.search,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
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
          const LanguageButton(),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(AppConfig.paddingScreen),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchStations,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _onClearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConfig.radiusInput),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),

          // Results
          Expanded(
            child: searchAsync.when(
              loading: () => const StationListShimmer(),
              error: (error, stack) => _buildError(context, error),
              data: (state) {
                if (state.isLoading && state.results.isEmpty) {
                  return const StationListShimmer();
                }

                if (state.showEmptyState) {
                  return _buildEmptyState(context, state.query);
                }

                if (state.results.isEmpty) {
                  return _buildInitialState(context);
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConfig.paddingScreen,
                    ),
                    itemCount: state.results.length + 1,
                    cacheExtent: 500, // Pre-render off-screen items
                    addAutomaticKeepAlives:
                        false, // Don't keep state unnecessarily
                    itemBuilder: (context, index) {
                      if (index < state.results.length) {
                        final station = state.results[index];
                        return StaggeredListItem(
                          index: index,
                          child: StationCard(
                            key: ValueKey(station.stationUuid),
                            station: station,
                          ),
                        );
                      }

                      // Bottom loading/end indicator
                      if (state.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppConfig.spacingL,
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final l10n = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: AppConfig.iconSizeLarge,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConfig.spacingL),
          Text(
            l10n.searchForStations,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConfig.spacingS),
          Text(
            l10n.enterStationName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    final l10n = S.of(context);
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: l10n.noSearchResultsTitle,
      message: l10n.noSearchResultsMessage,
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final l10n = S.of(context);
    return ErrorStateWidget(
      title: l10n.errorSearchingStations,
      error: error,
      onRetry: () => ref.read(searchProvider.notifier).search(
            _searchController.text,
          ),
    );
  }
}
