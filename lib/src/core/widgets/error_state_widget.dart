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
    this.title = 'Something went wrong',
    this.message,
    this.error,
    this.icon = Icons.error_outline,
    this.retryLabel = 'Retry',
    super.key,
  });

  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  /// Error title (defaults to "Something went wrong")
  final String title;

  /// Optional descriptive message
  final String? message;

  /// Optional error object to display details
  final Object? error;

  /// Icon to display (defaults to error_outline)
  final IconData icon;

  /// Label for retry button (defaults to "Retry")
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              semanticLabel: 'Error',
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
            ElevatedButton.icon(
              onPressed: () {
                unawaited(Haptics.light());
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, AppConfig.buttonHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
