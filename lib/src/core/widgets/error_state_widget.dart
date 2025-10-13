import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuneatlas/src/src.dart';

/// A reusable error state widget that displays consistent error UI across the app.
///
/// Features:
/// - Standardized error icon and messaging
/// - Built-in haptic feedback on retry
/// - Customizable title, message, and retry action
/// - Accessibility support with semantic labels
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.onRetry,
    required this.title,
    this.message,
    this.error,
    this.icon = Icons.error_outline,
    super.key,
  });

  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  /// Error title
  final String title;

  /// Optional descriptive message
  final String? message;

  /// Optional error object to display details
  final Object? error;

  /// Icon to display (defaults to error_outline)
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppConfig.iconSizeLarge,
              color: theme.colorScheme.error,
              semanticLabel: l10n.errorSemanticLabel,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null || error != null) ...[
              const SizedBox(height: 8),
              Text(
                message ?? error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                unawaited(Haptics.light());
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
              style: FilledButton.styleFrom(
                minimumSize: const Size(120, AppConfig.buttonHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
