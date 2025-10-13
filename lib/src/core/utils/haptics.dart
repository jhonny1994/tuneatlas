import 'package:flutter/services.dart';
import 'package:tuneatlas/src/src.dart';

/// Centralized haptic feedback utility
/// Provides consistent tactile feedback across the app
class Haptics {
  // Prevent instantiation
  Haptics._();

  /// Light impact feedback for subtle interactions
  /// Use for: taps, selections, minor actions
  static Future<void> light() async {
    if (!AppConfig.enableHaptics) return;
    await HapticFeedback.lightImpact();
  }

  /// Selection feedback for toggle-like interactions
  /// Use for: switches, checkboxes, radio buttons, segmented controls
  static Future<void> selection() async {
    if (!AppConfig.enableHaptics) return;
    await HapticFeedback.selectionClick();
  }

  /// Medium impact feedback for important actions
  /// Use for: confirmations, successful operations, significant changes
  static Future<void> medium() async {
    if (!AppConfig.enableHaptics) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact feedback for critical actions
  /// Use for: errors, warnings, destructive actions
  static Future<void> heavy() async {
    if (!AppConfig.enableHaptics) return;
    await HapticFeedback.heavyImpact();
  }

  /// Vibrate feedback for notifications and alerts
  /// Use for: incoming messages, alerts, reminders
  static Future<void> vibrate() async {
    if (!AppConfig.enableHaptics) return;
    await HapticFeedback.vibrate();
  }

  // Semantic convenience methods for common use cases

  /// Success feedback (medium impact)
  static Future<void> success() async => medium();

  /// Error feedback (heavy impact)
  static Future<void> error() async => heavy();

  /// Button press feedback (light impact)
  static Future<void> buttonPress() async => light();

  /// Toggle feedback (selection click)
  static Future<void> toggle() async => selection();
}
