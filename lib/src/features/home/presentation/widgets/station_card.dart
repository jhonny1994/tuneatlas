import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tuneatlas/src/core/core.dart';

/// Displays a radio station in a card format
class StationCard extends StatelessWidget {
  const StationCard({
    required this.station,
    this.onTap,
    super.key,
  });

  final Station station;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                      station.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Country and tags
                    Text(
                      _buildSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Codec and bitrate
                    _buildMetadata(context),
                  ],
                ),
              ),

              // Play button
              Icon(
                Icons.play_circle_outline,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build station logo
  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: station.favicon.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: station.favicon,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
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

  /// Build subtitle with country and tags
  String _buildSubtitle() {
    final parts = <String>[];

    if (station.country.isNotEmpty) {
      parts.add(station.country);
    }

    if (station.tags != null && station.tags!.isNotEmpty) {
      // Take first tag only
      final firstTag = station.tags!.split(',').first.trim();
      if (firstTag.isNotEmpty) {
        parts.add(firstTag);
      }
    }

    return parts.join(' • ');
  }

  /// Build metadata row (codec and bitrate)
  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = <String>[];

    if (station.codec.isNotEmpty) {
      metadata.add(station.codec.toUpperCase());
    }

    // Only show bitrate if greater than 0
    if (station.bitrate > 0) {
      metadata.add('${station.bitrate} kbps');
    }

    if (metadata.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            metadata.join(' • '),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
