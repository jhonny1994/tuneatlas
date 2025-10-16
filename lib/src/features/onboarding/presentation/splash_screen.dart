import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Splash screen shown during app initialization
/// Displays loading, success, or error states
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = ref.watch(appInitializationProvider);

    return Scaffold(
      body: Center(
        child: initState.when(
          loading: () => _buildLoading(context),
          success: () => _buildSuccess(context),
          error: (message) => _buildError(context, message, ref),
        ),
      ),
    );
  }

  /// Loading state UI
  Widget _buildLoading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo/icon placeholder
        Icon(
          Icons.radio,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 32),

        // App name
        Text(
          l10n.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 48),

        // Loading indicator
        const CircularProgressIndicator(),
        const SizedBox(height: 16),

        Text(
          l10n.initializingApp,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }

  /// Success state UI (briefly shown before navigation)
  Widget _buildSuccess(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.ready,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  /// Error state UI with retry button
  Widget _buildError(BuildContext context, String message, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 24),

          // Error title
          Text(
            l10n.failedToInitialize,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Error message - localize the error key
          Text(
            _getLocalizedError(l10n, message),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Retry button
          FilledButton.icon(
            onPressed: () =>
                ref.read(appInitializationProvider.notifier).retry(),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  /// Map error keys to localized messages
  String _getLocalizedError(AppLocalizations l10n, String errorKey) {
    // If it's already a full message (backward compatibility), return it
    if (errorKey.contains(' ')) {
      return errorKey;
    }

    // Map error keys to localized strings
    switch (errorKey) {
      case 'errorFailedToConnect':
        return l10n.errorFailedToConnect;
      default:
        return l10n.somethingWentWrong;
    }
  }
}
