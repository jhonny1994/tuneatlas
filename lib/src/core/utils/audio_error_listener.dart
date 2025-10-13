import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Extension to simplify audio error listening across screens
extension AudioErrorListener on WidgetRef {
  /// Listen to audio player errors and show snackbar notifications
  /// Call this in the build method of screens that play audio
  ///
  /// NOTE: Snackbar only shows when mini player is NOT visible to avoid double error display
  void listenToAudioErrors(BuildContext context) {
    listen<AsyncValue<AudioState>>(
      audioPlayerProvider,
      (previous, next) {
        next.whenData((state) {
          // Only show snackbar if:
          // 1. There is an error
          // 2. There is NO current station (mini player not visible)
          // This prevents double error display (snackbar + mini player error banner)
          if (state.error != null && state.currentStation == null) {
            _showErrorSnackBar(context, state.error!);
          }
        });
      },
    );
  }

  /// Show error snackbar with consistent styling
  void _showErrorSnackBar(BuildContext context, String message) {
    // Check if widget is still mounted before showing snackbar
    if (!context.mounted) return;

    // Get localized error message
    final localizedMessage =
        AudioErrorMapper.getLocalizedError(context, message);
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(localizedMessage),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n.cancel,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
