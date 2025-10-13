import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Displays a radio station in a card format
class StationCard extends ConsumerStatefulWidget {
  const StationCard({
    required this.station,
    this.onTap,
    super.key,
  });

  final Station station;
  final VoidCallback? onTap;

  @override
  ConsumerState<StationCard> createState() => _StationCardState();
}

class _StationCardState extends ConsumerState<StationCard> {
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkFavoriteStatus());
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await ref
        .read(favoritesProvider.notifier)
        .isFavorite(widget.station.stationUuid);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);

    // Add haptic feedback for toggle action
    unawaited(Haptics.toggle());

    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.station);

    if (mounted) {
      await _checkFavoriteStatus();
    }
  }

  void _handleTap() {
    // Add haptic feedback
    unawaited(Haptics.light());

    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      // Default: play station
      unawaited(
        ref.read(audioPlayerProvider.notifier).playStation(widget.station),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioState = ref.watch(audioPlayerProvider);

    // Check if this station is currently playing
    final isCurrentStation = audioState.whenOrNull(
          data: (state) =>
              state.currentStation?.stationUuid == widget.station.stationUuid,
        ) ??
        false;

    final isPlaying = audioState.whenOrNull(
          data: (state) => state.isPlaying && isCurrentStation,
        ) ??
        false;

    final isLoadingAudio = audioState.whenOrNull(
          data: (state) => state.isLoading && isCurrentStation,
        ) ??
        false;

    return AnimatedScale(
      scale: _isPressed ? AppConfig.pressedScale : 1.0,
      duration: AppConfig.fastAnimation,
      curve: AppConfig.defaultCurve,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isCurrentStation ? 4 : 1, // Enhanced from 2 to 4
        shadowColor: isCurrentStation 
          ? theme.colorScheme.primary.withValues(alpha: 0.3)
          : null,
        child: InkWell(
          onTap: _handleTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            decoration: isCurrentStation
                ? BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.8), // Enhanced from 0.5 to 0.8
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    // Add glow effect for active station
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Station logo/favicon
                  _buildLogo(context),
                  const SizedBox(width: 12),

                  // Station info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Station name
                        Text(
                          widget.station.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700, // Enhanced from w600
                            letterSpacing: -0.3, // Tighter for display text
                            color: isCurrentStation
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Station description
                        const SizedBox(height: 4),
                        _buildMetadata(context),
                      ],
                    ),
                  ),

                  // Play/pause button (for current station)
                  if (isCurrentStation) ...[
                    const SizedBox(width: 8),
                    if (isLoadingAudio)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    else
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () => ref
                            .read(audioPlayerProvider.notifier)
                            .togglePlayPause(),
                      ),
                  ],

                  // Favorite button
                  IconButton(
                    onPressed: _isLoading ? null : _toggleFavorite,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                  ),
                ],
              ), // Row
            ), // Padding
          ), // Container
        ), // InkWell
      ), // Card
    ); // AnimatedScale
  }

  /// Build station logo
  Widget _buildLogo(BuildContext context) {
    final audioState = ref.watch(audioPlayerProvider);
    final isCurrentStation = audioState.whenOrNull(
          data: (state) =>
              state.currentStation?.stationUuid == widget.station.stationUuid,
        ) ??
        false;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        // Add shadow when active
        boxShadow: isCurrentStation ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: widget.station.favicon.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.station.favicon,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return _buildFallbackIcon(context);
                },
              ),
            )
          : _buildFallbackIcon(context),
    );
  }

  /// Fallback icon when logo fails to load
  Widget _buildFallbackIcon(BuildContext context) {
    return Icon(
      Icons.radio,
      size: 32,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Build metadata row
  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);
    final tags = <String>[];

    if (widget.station.country.isNotEmpty) {
      tags.add(widget.station.country.toUpperCase());
    }

    if (widget.station.language != null &&
        widget.station.language!.isNotEmpty) {
      tags.addAll(
        widget.station.language!.split(',').map(
              (lang) => lang.trim().toUpperCase(),
            ),
      );
    }
    if (widget.station.tags != null && widget.station.tags!.isNotEmpty) {
      tags.addAll(
        widget.station.tags!.split(',').map(
              (tag) => tag.trim().toUpperCase(),
            ),
      );
    }
    if (tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: tags
          .map(
            (data) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                data,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5, // Better tag readability
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
