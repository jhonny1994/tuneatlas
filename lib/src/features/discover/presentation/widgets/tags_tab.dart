import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Tags discovery tab - uses generic DiscoverListTab for DRY
class TagsTab extends ConsumerWidget {
  const TagsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return DiscoverListTab(
      asyncData: tagsAsync,
      filterType: 'tag',
      emptyIcon: Icons.sell_outlined,
      emptyTitle: l10n.noTagsTitle,
      maxItems: AppConfig.maxDiscoverTags,
      onRetry: () => ref.invalidate(tagsProvider),
      itemBuilder: (BuildContext ctx, Facet tag) => DiscoverListTile(
        item: tag,
        filterType: 'tag',
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.tertiaryContainer,
          child: Icon(
            Icons.sell,
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
      ),
    );
  }
}
