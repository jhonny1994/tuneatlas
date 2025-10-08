import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/features/discover/data/languages_provider.dart';

class LanguagesTab extends ConsumerWidget {
  const LanguagesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languagesAsync = ref.watch(languagesProvider);

    return languagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
      data: (languages) {
        if (languages.isEmpty) {
          return _buildEmpty(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.language,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(language.name),
                subtitle: Text('${language.stationCount} stations'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  '/filtered-stations?filterType=language&filterValue=${language.name}&title=${Uri.encodeComponent(language.name)}',
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
          const Text('Failed to load languages'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(languagesProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Text('No languages available'),
    );
  }
}
