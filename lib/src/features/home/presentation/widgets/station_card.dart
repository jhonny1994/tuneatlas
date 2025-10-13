import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return AnimatedRotation(
      turns: _isPressed ? -0.002 : 0, // Subtle 0.72 degree rotation
      duration: AppConfig.fastAnimation,
      curve: AppConfig.defaultCurve,
      child: AnimatedScale(
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
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.8), // Enhanced from 0.5 to 0.8
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      // Add glow effect for active station
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Logo + Info + Favorite
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Station logo/favicon (larger)
                        _buildLogo(context),
                        const SizedBox(width: 16),

                        // Station info (expanded)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Station name
                              Text(
                                widget.station.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight:
                                      FontWeight.w700, // Enhanced from w600
                                  letterSpacing:
                                      -0.3, // Tighter for display text
                                  color: isCurrentStation
                                      ? theme.colorScheme.primary
                                      : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Technical info (Country, Codec, Bitrate)
                              const SizedBox(height: 4),
                              _buildTechnicalInfo(context, isCurrentStation),

                              // Tags
                              const SizedBox(height: 8),
                              _buildMetadata(context),
                            ],
                          ),
                        ),

                        // Favorite button
                        AnimatedScale(
                          scale: _isLoading
                              ? 0.8
                              : 1.0, // Slight scale down when loading
                          duration: AppConfig.fastAnimation,
                          child: IconButton(
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
                        ),
                      ],
                    ),

                    // Action buttons (Material You style)
                    const SizedBox(height: 12),
                    _buildActionButtons(
                      context,
                      isCurrentStation,
                      isPlaying,
                      isLoadingAudio,
                    ),
                  ],
                ),
              ), // Padding
            ), // Container
          ), // InkWell
        ), // Card
      ), // AnimatedScale
    ); // AnimatedRotation
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
      width: 80, // Increased from 60 for Material You
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        // Add shadow when active
        boxShadow: isCurrentStation
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: widget.station.favicon.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.station.favicon,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return _buildFallbackIcon(context);
                },
              ),
            )
          : _buildFallbackIcon(context),
    );
  }

  /// Build technical info (Country, Codec, Bitrate) - ONLY REAL API DATA
  Widget _buildTechnicalInfo(BuildContext context, bool isCurrentStation) {
    final theme = Theme.of(context);
    final infoParts = <Widget>[];

    // Country (always available)
    if (widget.station.country.isNotEmpty) {
      infoParts.add(
        Text(
          widget.station.country,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isCurrentStation
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // Codec (MP3, AAC, etc.)
    if (widget.station.codec.isNotEmpty) {
      infoParts.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.station.codec.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    // Bitrate (only if > 0)
    if (widget.station.bitrate > 0) {
      // Determine quality indicator
      final isHQ = widget.station.bitrate >= 128;
      infoParts.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isHQ
                ? theme.colorScheme.tertiaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isHQ)
                Icon(
                  Icons.high_quality,
                  size: 12,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              if (isHQ) const SizedBox(width: 2),
              Text(
                '${widget.station.bitrate} kbps',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isHQ
                      ? theme.colorScheme.onTertiaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Votes/Popularity (only if > 0)
    if (widget.station.votes > 0) {
      infoParts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.thumb_up,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              _formatVotes(widget.station.votes),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (infoParts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: infoParts,
    );
  }

  /// Format vote count (1234 -> 1.2K)
  String _formatVotes(int votes) {
    if (votes >= 1000000) {
      return '${(votes / 1000000).toStringAsFixed(1)}M';
    }
    if (votes >= 1000) {
      return '${(votes / 1000).toStringAsFixed(1)}K';
    }
    return votes.toString();
  }

  /// Build Material You action buttons
  Widget _buildActionButtons(
    BuildContext context,
    bool isCurrentStation,
    bool isPlaying,
    bool isLoadingAudio,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Play/Pause button (primary action)
        Expanded(
          child: FilledButton.icon(
            onPressed: isCurrentStation
                ? () => ref.read(audioPlayerProvider.notifier).togglePlayPause()
                : _handleTap,
            icon: isLoadingAudio
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Icon(
                    isCurrentStation
                        ? (isPlaying ? Icons.pause : Icons.play_arrow)
                        : Icons.play_arrow,
                    size: 20,
                  ),
            label: Text(
              isCurrentStation
                  ? (isPlaying ? l10n.pause : l10n.play)
                  : l10n.playNow,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // More options button
        FilledButton.tonal(
          onPressed: () => _showStationOptions(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: const Size(48, 48),
          ),
          child: const Icon(Icons.more_horiz, size: 20),
        ),
      ],
    );
  }

  /// Show station options (placeholder for future features)
  Future<void> _showStationOptions(BuildContext context) async {
    unawaited(Haptics.light());
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(l10n.shareStation),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.visitWebsite),
                enabled: widget.station.homepage?.isNotEmpty ?? false,
                onTap: () => launchUrl(
                  Uri.parse(widget.station.homepage!),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        );
      },
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

  /// Build metadata row (languages and tags only - max 3 total)
  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);
    final tags = <String>[];

    // Add languages
    if (widget.station.language != null &&
        widget.station.language!.isNotEmpty) {
      tags.addAll(
        widget.station.language!.split(',').map(
              (lang) => lang.trim(),
            ),
      );
    }

    // Add tags
    if (widget.station.tags != null && widget.station.tags!.isNotEmpty) {
      tags.addAll(
        widget.station.tags!.split(',').map(
              (tag) => tag.trim(),
            ),
      );
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    // Show max 3 tags + overflow indicator
    const maxTags = 3;
    final displayTags = tags.take(maxTags).toList();
    final hasMore = tags.length > maxTags;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displayTags.map(
          (data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        ),
        if (hasMore)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              AppLocalizations.of(context)!.tagsOverflow(tags.length - maxTags),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
