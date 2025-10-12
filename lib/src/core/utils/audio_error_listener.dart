import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Extension to simplify audio error listening across screens
extension AudioErrorListener on WidgetRef {
  /// Listen to audio player errors and show snackbar notifications
  /// Call this in the build method of screens that play audio
  void listenToAudioErrors(BuildContext context) {
    listen<AsyncValue<AudioState>>(
      audioPlayerProvider,
      (previous, next) {
        next.whenData((state) {
          if (state.error != null) {
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
