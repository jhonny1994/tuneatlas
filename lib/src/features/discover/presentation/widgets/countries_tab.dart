import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Countries discovery tab - uses generic DiscoverListTab for DRY
class CountriesTab extends ConsumerWidget {
  const CountriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return DiscoverListTab(
      asyncData: countriesAsync,
      filterType: 'country',
      emptyIcon: Icons.public_off,
      emptyTitle: l10n.noCountriesTitle,
      onRetry: () => ref.invalidate(countriesProvider),
      itemBuilder: (BuildContext ctx, Facet country) => DiscoverListTile(
        item: country,
        filterType: 'country',
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            country.name.isNotEmpty ? country.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
