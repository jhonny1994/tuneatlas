import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuneatlas/src/src.dart';

/// Shimmer loading placeholder for station cards - matches new simplified layout
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
        padding: const EdgeInsets.all(AppConfig.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Header with logo and info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo shimmer (64x64)
                _buildShimmerBox(
                  width: AppConfig.stationImageSize,
                  height: AppConfig.stationImageSize,
                  radius: AppConfig.radiusMd,
                  color: shimmerColor,
                ),
                const SizedBox(width: AppConfig.space3),

                // Station info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Station name
                      _buildShimmerBox(
                        width: double.infinity,
                        height: 18,
                        radius: AppConfig.radiusSm,
                        color: shimmerColor,
                      ),
                      const SizedBox(height: AppConfig.space2),

                      // Metadata row
                      _buildShimmerBox(
                        width: 140,
                        height: 14,
                        radius: AppConfig.radiusSm,
                        color: shimmerColor,
                      ),
                      const SizedBox(height: AppConfig.space2),

                      // Tags row
                      Row(
                        children: [
                          _buildShimmerBox(
                            width: 48,
                            height: 22,
                            radius: AppConfig.radiusSm,
                            color: shimmerColor,
                          ),
                          const SizedBox(width: AppConfig.space2),
                          _buildShimmerBox(
                            width: 56,
                            height: 22,
                            radius: AppConfig.radiusSm,
                            color: shimmerColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConfig.space3),

            // Row 2: Action row
            Row(
              children: [
                // Play button shimmer
                _buildShimmerBox(
                  width: 36,
                  height: 36,
                  radius: AppConfig.radiusMd,
                  color: shimmerColor,
                ),
                const Spacer(),

                // Share button shimmer
                _buildShimmerBox(
                  width: 32,
                  height: 32,
                  radius: AppConfig.radiusSm,
                  color: shimmerColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    required double radius,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      },
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
      padding: const EdgeInsets.all(AppConfig.space4),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const StationCardShimmer();
      },
    );
  }
}
