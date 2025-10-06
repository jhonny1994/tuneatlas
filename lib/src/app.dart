import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tuneatlas/src/src.dart';

class TuneAtlasApp extends ConsumerWidget {
  const TuneAtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'TuneAtlas',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
