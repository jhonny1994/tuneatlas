import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for TuneAtlas
/// Provides smooth, context-aware navigation animations with accessibility support
class AppPageTransitions {
  AppPageTransitions._();

  /// Helper to check if animations should be disabled for accessibility
  static bool _shouldDisableAnimations(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }

  /// Fade transition - Subtle for modal-like navigation
  static CustomTransitionPage<T> fadeTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (_shouldDisableAnimations(context)) {
          return child;
        }
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Slide from right - For hierarchical forward navigation
  static CustomTransitionPage<T> slideRightTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (_shouldDisableAnimations(context)) {
          return child;
        }
        const begin = Offset(1, 0); // Start from right
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Slide from bottom - For modal-style screens
  static CustomTransitionPage<T> slideUpTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (_shouldDisableAnimations(context)) {
          return child;
        }
        const begin = Offset(0, 1); // Start from bottom
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutExpo, // Emphasized deceleration
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Scale + Fade - For bottom navigation transitions
  /// Creates smooth feeling when switching between peer screens
  static CustomTransitionPage<T> scaleFadeTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (_shouldDisableAnimations(context)) {
          return child;
        }
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Shared Axis Z - For hierarchical navigation with depth
  /// Screen being left scales down slightly while new screen fades in
  static CustomTransitionPage<T> sharedAxisTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (_shouldDisableAnimations(context)) {
          return child;
        }
        // Forward animation (entering)
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1, curve: Curves.easeInOut),
        );
        final scaleIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 1, curve: Curves.easeInOut),
        );

        // Reverse animation (exiting)
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 0.7, curve: Curves.easeInOut),
        );
        final scaleOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 1, curve: Curves.easeInOut),
        );

        return Stack(
          children: [
            // Exiting screen (if any)
            if (secondaryAnimation.status != AnimationStatus.dismissed)
              FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0).animate(fadeOut),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 0.92).animate(scaleOut),
                  child: child,
                ),
              ),
            // Entering screen
            FadeTransition(
              opacity: fadeIn,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.08, end: 1).animate(scaleIn),
                child: child,
              ),
            ),
          ],
        );
      },
      transitionDuration: duration,
    );
  }
}
