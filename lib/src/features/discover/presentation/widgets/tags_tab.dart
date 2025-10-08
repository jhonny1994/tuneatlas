import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/features/discover/data/tags_provider.dart';

class TagsTab extends ConsumerWidget {
  const TagsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);

    return tagsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
      data: (tags) {
        if (tags.isEmpty) {
          return _buildEmpty(context);
        }

        // Show only top 100 tags for better performance
        final topTags = tags.take(100).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topTags.length,
          itemBuilder: (context, index) {
            final tag = topTags[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer,
                  child: Icon(
                    Icons.sell,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
                title: Text(tag.name),
                subtitle: Text('${tag.stationCount} stations'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  '/filtered-stations?filterType=tag&filterValue=${tag.name}&title=${Uri.encodeComponent(tag.name)}',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          const Text('Failed to load tags'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(tagsProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Text('No tags available'),
    );
  }
}
