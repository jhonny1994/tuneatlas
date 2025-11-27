import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuneatlas/src/src.dart';
import 'package:url_launcher/url_launcher.dart';

/// Simplified, minimalist station card
/// Clean layout: Image | Name + Info | Actions
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
  bool _isLoadingFavorite = true;

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
        _isLoadingFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoadingFavorite = true);
    unawaited(Haptics.toggle());
    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.station);
    if (mounted) {
      await _checkFavoriteStatus();
    }
  }

  void _handleTap() {
    unawaited(Haptics.light());
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      unawaited(
        ref.read(audioPlayerProvider.notifier).playStation(widget.station),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioState = ref.watch(audioPlayerProvider);

    final isCurrentStation = audioState.whenOrNull(
          data: (state) =>
              state.currentStation?.stationUuid == widget.station.stationUuid,
        ) ??
        false;

    final isPlaying = audioState.whenOrNull(
          data: (state) => state.isPlaying && isCurrentStation,
        ) ??
        false;

    final isLoading = audioState.whenOrNull(
          data: (state) => state.isLoading && isCurrentStation,
        ) ??
        false;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.space2),
      child: Material(
        color: isCurrentStation
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConfig.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(AppConfig.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppConfig.space3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConfig.radiusLg),
              border: Border.all(
                color: isCurrentStation
                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Station image with play indicator overlay
                _buildImage(context, isCurrentStation, isPlaying, isLoading),
                const SizedBox(width: AppConfig.space3),

                // Station info
                Expanded(
                  child: _buildInfo(context, isCurrentStation),
                ),

                // Actions
                _buildActions(context, isCurrentStation, isPlaying, isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    bool isCurrentStation,
    bool isPlaying,
    bool isLoading,
  ) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Image container
        Container(
          width: AppConfig.stationImageSize,
          height: AppConfig.stationImageSize,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppConfig.radiusMd),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConfig.radiusMd),
            child: widget.station.favicon.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.station.favicon,
                    width: AppConfig.stationImageSize,
                    height: AppConfig.stationImageSize,
                    fit: BoxFit.cover,
                    memCacheHeight: 112,
                    maxHeightDiskCache: 168,
                    placeholder: (_, __) => _buildPlaceholder(context),
                    errorWidget: (_, __, ___) => _buildPlaceholder(context),
                  )
                : _buildPlaceholder(context),
          ),
        ),

        // Play state overlay
        if (isCurrentStation)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppConfig.radiusMd),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: AppConfig.iconMd,
                        height: AppConfig.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isPlaying
                            ? Icons.equalizer_rounded
                            : Icons.pause_rounded,
                        color: Colors.white,
                        size: AppConfig.iconMd,
                      ),
              ),
            ),
          ),

        // Favorite indicator
        if (_isFavorite && !isCurrentStation)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppConfig.radiusSm),
              ),
              child: Icon(
                Icons.favorite,
                size: 12,
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.radio,
        size: AppConfig.iconLg,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, bool isCurrentStation) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Station name
        Text(
          widget.station.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isCurrentStation
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppConfig.space1),

        // Country + Quality badge
        Row(
          children: [
            if (widget.station.country.isNotEmpty) ...[
              Flexible(
                child: Text(
                  widget.station.country,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.station.bitrate >= 128 ||
                  widget.station.codec.isNotEmpty)
                const SizedBox(width: AppConfig.space2),
            ],
            // Quality indicators
            if (widget.station.bitrate >= 128)
              _buildBadge(
                context,
                'HQ',
                theme.colorScheme.primary.withValues(alpha: 0.15),
                theme.colorScheme.primary,
              )
            else if (widget.station.codec.isNotEmpty)
              _buildBadge(
                context,
                widget.station.codec.toUpperCase(),
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),

        // Tags (simplified - max 2)
        if (_hasTags) ...[
          const SizedBox(height: AppConfig.space1),
          _buildTags(context),
        ],
      ],
    );
  }

  bool get _hasTags =>
      (widget.station.tags?.isNotEmpty ?? false) ||
      (widget.station.language?.isNotEmpty ?? false);

  Widget _buildTags(BuildContext context) {
    final theme = Theme.of(context);
    final tags = <String>[];

    if (widget.station.language?.isNotEmpty ?? false) {
      tags.add(widget.station.language!.split(',').first.trim());
    }
    if (widget.station.tags?.isNotEmpty ?? false) {
      tags.addAll(
        widget.station.tags!.split(',').take(2).map((t) => t.trim()),
      );
    }

    final displayTags = tags.take(2).toList();

    return Wrap(
      spacing: AppConfig.space1,
      children: displayTags
          .map(
            (tag) => Text(
              tag,
              style: theme.textTheme.labelSmall?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    String label,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConfig.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    bool isCurrentStation,
    bool isPlaying,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Favorite button
        IconButton(
          onPressed: _isLoadingFavorite ? null : _toggleFavorite,
          tooltip: _isFavorite
              ? l10n.removeFromFavoritesLabel
              : l10n.addToFavoritesLabel,
          visualDensity: VisualDensity.compact,
          icon: _isLoadingFavorite
              ? SizedBox(
                  width: AppConfig.iconSm,
                  height: AppConfig.iconSm,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                  size: AppConfig.iconMd,
                  color: _isFavorite
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
        ),

        // More options
        IconButton(
          onPressed: () => _showOptions(context),
          tooltip: l10n.moreOptionsLabel,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.more_vert,
            size: AppConfig.iconMd,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _showOptions(BuildContext context) async {
    unawaited(Haptics.light());
    final l10n = S.of(context);
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConfig.space2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppConfig.space4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Station header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConfig.space4,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppConfig.radiusMd),
                      child: widget.station.favicon.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.station.favicon,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.radio,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                    ),
                    const SizedBox(width: AppConfig.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.station.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.station.country.isNotEmpty)
                            Text(
                              widget.station.country,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConfig.space3),
              const Divider(height: 1),

              // Options
              ListTile(
                leading: const Icon(Icons.play_arrow_rounded),
                title: Text(l10n.playNow),
                onTap: () {
                  Navigator.pop(context);
                  _handleTap();
                },
              ),
              ListTile(
                leading: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                ),
                title: Text(
                  _isFavorite
                      ? l10n.removeFromFavoritesLabel
                      : l10n.addToFavoritesLabel,
                ),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(_toggleFavorite());
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(l10n.shareStation),
                onTap: () async {
                  Navigator.pop(context);
                  await SharePlus.instance.share(
                    ShareParams(
                      text: l10n.shareMessage(
                        widget.station.name,
                        '${AppConfig.deepLinkBaseUrl}/station/${widget.station.stationUuid}',
                      ),
                    ),
                  );
                },
              ),
              if (widget.station.homepage?.isNotEmpty ?? false)
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.visitWebsite),
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(
                      launchUrl(
                        Uri.parse(widget.station.homepage!),
                        mode: LaunchMode.externalApplication,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
