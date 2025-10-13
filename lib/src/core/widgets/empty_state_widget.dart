import 'package:flutter/material.dart';
import 'package:tuneatlas/src/src.dart';

/// A reusable empty state widget that displays consistent UI across the app.
///
/// Features:
/// - Standardized icon, title, and message layout
/// - Consistent spacing and styling
/// - Optional action button
/// - Accessibility support with semantic labels
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  /// Icon to display (e.g., Icons.favorite_border, Icons.search_off)
  final IconData icon;

  /// Title text (e.g., "No favorites yet")
  final String title;

  /// Descriptive message text
  final String message;

  /// Optional action button icon
  final IconData? action;

  /// Optional action button label
  final String? actionLabel;

  /// Optional action button callback
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.paddingContent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppConfig.iconSizeLarge,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              semanticLabel: 'Empty state',
            ),
            const SizedBox(height: AppConfig.spacingL),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConfig.spacingS),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null &&
                actionLabel != null &&
                onActionPressed != null) ...[
              const SizedBox(height: AppConfig.spacingL),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: Icon(action),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, AppConfig.buttonHeight),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
