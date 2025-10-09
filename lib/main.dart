import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneatlas/src/src.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before app starts
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // Override the sharedPreferences provider with real instance
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: DevicePreview(
        builder: (context) => const TuneAtlasApp(),
        enabled: Platform.isWindows && kDebugMode,
      ),
    ),
  );
}

class TuneAtlasApp extends ConsumerWidget {
  const TuneAtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'TuneAtlas',
      debugShowCheckedModeBanner: false,
      themeMode: theme,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      // GoRouter configuration
      routerConfig: router,
    );
  }
}
