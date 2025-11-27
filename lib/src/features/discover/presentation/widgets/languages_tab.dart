import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Languages discovery tab - uses generic DiscoverListTab for DRY
class LanguagesTab extends ConsumerWidget {
  const LanguagesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languagesAsync = ref.watch(languagesProvider);
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return DiscoverListTab(
      asyncData: languagesAsync,
      filterType: 'language',
      emptyIcon: Icons.language_outlined,
      emptyTitle: l10n.noLanguagesTitle,
      onRetry: () => ref.invalidate(languagesProvider),
      itemBuilder: (BuildContext ctx, Facet language) => DiscoverListTile(
        item: language,
        filterType: 'language',
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(
            Icons.language,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
