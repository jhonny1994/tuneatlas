import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    // Listen for audio errors and show snackbar
    ref.listenToAudioErrors(context);

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
            l10n.discover,
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
              tooltip: l10n.toggleThemeLabel,
              onPressed: () async {
                unawaited(Haptics.toggle());
                await ref.read(themeModeProvider.notifier).toggle();
              },
            ),
            const LanguageButton(),
          ],
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.6,
            ),
            tabs: [
              Tab(text: l10n.countries),
              Tab(text: l10n.languages),
              Tab(text: l10n.tags),
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
