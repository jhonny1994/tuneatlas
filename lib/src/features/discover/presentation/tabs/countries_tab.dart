import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/features/discover/data/countries_provider.dart';

class CountriesTab extends ConsumerWidget {
  const CountriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return countriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
      data: (countries) {
        if (countries.isEmpty) {
          return _buildEmpty(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    country.name.isNotEmpty
                        ? country.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(country.name),
                subtitle: Text('${country.stationCount} stations'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  '/filtered-stations?filterType=country&filterValue=${country.code}&title=${Uri.encodeComponent(country.name)}',
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
          const Text('Failed to load countries'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(countriesProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Text('No countries available'),
    );
  }
}
