import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

/// Generic reusable tab for Discover screen lists (Countries, Languages, Tags)
/// Eliminates code duplication across the three tabs
class DiscoverListTab extends ConsumerWidget {
  const DiscoverListTab({
    required this.asyncData,
    required this.filterType,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.onRetry,
    required this.itemBuilder,
    this.maxItems,
    super.key,
  });

  /// The async data to display
  final AsyncValue<List<Facet>> asyncData;

  /// Filter type for navigation (country, language, tag)
  final String filterType;

  /// Icon to show in empty state
  final IconData emptyIcon;

  /// Title for empty state
  final String emptyTitle;

  /// Retry callback
  final VoidCallback onRetry;

  /// Builder for individual items
  final Widget Function(BuildContext context, Facet item) itemBuilder;

  /// Optional max items to show (useful for tags)
  final int? maxItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncData.when(
      loading: () => const ListTileShimmer(),
      error: (error, stack) => _buildError(context, error),
      data: (items) {
        if (items.isEmpty) {
          return _buildEmpty(context);
        }

        final displayItems =
            maxItems != null ? items.take(maxItems!).toList() : items;

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConfig.paddingScreen),
            itemCount: displayItems.length,
            cacheExtent: 500,
            itemBuilder: (context, index) {
              final item = displayItems[index];
              return StaggeredListItem(
                index: index,
                child: itemBuilder(context, item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final l10n = S.of(context);
    return ErrorStateWidget(
      title: l10n.errorLoadingStations,
      error: error,
      onRetry: onRetry,
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = S.of(context);
    return EmptyStateWidget(
      icon: emptyIcon,
      title: emptyTitle,
      message: l10n.noData,
    );
  }
}

/// Helper widget to build a discover list tile
class DiscoverListTile extends StatelessWidget {
  const DiscoverListTile({
    required this.item,
    required this.filterType,
    required this.leading,
    super.key,
  });

  final Facet item;
  final String filterType;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final filterValue =
        filterType == 'country' ? (item.code ?? item.name) : item.name;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConfig.spacingS),
      child: ListTile(
        leading: leading,
        title: Text(item.name),
        subtitle: Text(l10n.stationsCount(item.stationCount)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          unawaited(Haptics.light());
          unawaited(
            context.push(
              '/filtered-stations?filterType=$filterType&filterValue=$filterValue&title=${Uri.encodeComponent(item.name)}',
            ),
          );
        },
      ),
    );
  }
}
