import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tuneatlas/src/src.dart';

/// A reusable widget that applies staggered animations to list items.
///
/// Only animates items within [AppConfig.maxStaggerItems] to maintain performance.
/// Respects system-level reduced motion preferences via [MediaQuery].
class StaggeredListItem extends StatelessWidget {
  const StaggeredListItem({
    required this.index,
    required this.child,
    this.duration,
    this.verticalOffset,
    super.key,
  });

  /// The position of this item in the list
  final int index;

  /// The child widget to animate
  final Widget child;

  /// Animation duration (defaults to [AppConfig.normalAnimation])
  final Duration? duration;

  /// Vertical slide offset in pixels (defaults to [AppConfig.staggerOffset])
  final double? verticalOffset;

  @override
  Widget build(BuildContext context) {
    final shouldAnimate = index < AppConfig.maxStaggerItems;

    // Respect reduced motion preference
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    if (!shouldAnimate || disableAnimations) {
      return child;
    }

    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration ?? AppConfig.normalAnimation,
      child: SlideAnimation(
        verticalOffset: verticalOffset ?? AppConfig.staggerOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
