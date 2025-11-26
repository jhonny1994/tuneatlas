import 'package:flutter/material.dart';
import 'package:tuneatlas/src/src.dart';

/// Maps error strings to localized error messages
class AudioErrorMapper {
  /// Get localized error message based on error string content
  static String getLocalizedError(BuildContext context, String error) {
    final l10n = S.of(context);

    // Match error keys from audio_player_service.dart
    if (error == 'errorFailedToConnect') {
      return l10n.errorFailedToConnect;
    } else if (error == 'errorConnectionTimeout') {
      return l10n.errorConnectionTimeout;
    } else if (error == 'errorStreamNotFound') {
      return l10n.errorStreamNotFound;
    } else if (error == 'errorAccessDenied') {
      return l10n.errorAccessDenied;
    } else if (error == 'errorNetworkIssue') {
      return l10n.errorNetworkIssue;
    } else if (error == 'errorUnsupportedFormat') {
      return l10n.errorUnsupportedFormat;
    } else if (error == 'errorFailedToPlay') {
      return l10n.errorFailedToPlay;
    } else if (error == 'errorFailedToResume') {
      return l10n.errorFailedToResume;
    }

    // Legacy pattern matching for backward compatibility
    else if (error.contains('timeout') ||
        error.contains('Connection timeout')) {
      return l10n.errorTimeout;
    } else if (error.contains('not found') || error.contains('404')) {
      return l10n.errorNotFound;
    } else if (error.contains('Access denied') ||
        error.contains('403') ||
        error.contains('401')) {
      return l10n.errorForbidden;
    } else if (error.contains('Network error') ||
        error.contains('network') ||
        error.contains('SocketException')) {
      return l10n.errorNetwork;
    } else if (error.contains('format') ||
        error.contains('Unsupported audio format')) {
      return l10n.errorFormat;
    } else if (error.contains('Failed to play') ||
        error.contains('Error playing')) {
      return l10n.errorPlayingStation;
    }

    // Default fallback
    return l10n.errorUnknown;
  }
}
