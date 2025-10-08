import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainer,
          foregroundColor: theme.colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Discover',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.6,
            ),
            tabs: const [
              Tab(text: 'Countries'),
              Tab(text: 'Languages'),
              Tab(text: 'Tags'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CountriesTab(),
            LanguagesTab(),
            TagsTab(),
          ],
        ),
      ),
    );
  }
}
