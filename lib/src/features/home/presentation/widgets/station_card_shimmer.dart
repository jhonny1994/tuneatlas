import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuneatlas/src/core/config/app_config.dart';

/// Shimmer loading placeholder for station cards
class StationCardShimmer extends StatefulWidget {
  const StationCardShimmer({super.key});

  @override
  State<StationCardShimmer> createState() => _StationCardShimmerState();
}

class _StationCardShimmerState extends State<StationCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConfig.shimmerDuration,
    );
    unawaited(_controller.repeat(reverse: true));

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.colorScheme.surfaceContainerHighest;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Logo shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),

            // Text shimmers
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Subtitle shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Container(
                          height: 12,
                          width: 150,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Metadata shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Container(
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Play button shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a list of shimmer cards
class StationListShimmer extends StatelessWidget {
  const StationListShimmer({this.itemCount = 10, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const StationCardShimmer();
      },
    );
  }
}
