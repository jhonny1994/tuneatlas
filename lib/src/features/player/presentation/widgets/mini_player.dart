import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuneatlas/src/src.dart';

/// Minimalist mini player with backdrop blur
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);

    return audioState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (state) {
        if (state.currentStation == null || state.isStopped) {
          return const SizedBox.shrink();
        }
        return _MiniPlayerContent(state: state);
      },
    );
  }
}

class _MiniPlayerContent extends ConsumerWidget {
  const _MiniPlayerContent({required this.state});

  final AudioState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error banner
              if (state.error != null) _buildErrorBanner(context, ref),

              // Main content
              SizedBox(
                height: AppConfig.miniPlayerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConfig.space4,
                  ),
                  child: Row(
                    children: [
                      // Album art
                      _buildArtwork(context),
                      const SizedBox(width: AppConfig.space3),

                      // Station info
                      Expanded(
                        child: _buildInfo(context, l10n),
                      ),

                      // Controls
                      _buildControls(context, ref, l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.space4,
        vertical: AppConfig.space2,
      ),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: AppConfig.iconXs,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppConfig.space2),
          Expanded(
            child: Text(
              AudioErrorMapper.getLocalizedError(context, state.error!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(audioPlayerProvider.notifier).stop(),
            child: Icon(
              Icons.close,
              size: AppConfig.iconXs,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork(BuildContext context) {
    final theme = Theme.of(context);
    final station = state.currentStation!;

    return Stack(
      children: [
        Container(
          width: AppConfig.miniPlayerImageSize,
          height: AppConfig.miniPlayerImageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig.radiusMd),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConfig.radiusMd),
            child: station.favicon.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: station.favicon,
                    width: AppConfig.miniPlayerImageSize,
                    height: AppConfig.miniPlayerImageSize,
                    fit: BoxFit.cover,
                    memCacheHeight: 96,
                    maxHeightDiskCache: 144,
                    placeholder: (_, __) => _buildArtworkPlaceholder(context),
                    errorWidget: (_, __, ___) =>
                        _buildArtworkPlaceholder(context),
                  )
                : _buildArtworkPlaceholder(context),
          ),
        ),

        // Play state overlay
        if (state.isPlaying || state.isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppConfig.radiusMd),
              ),
              child: Center(
                child: state.isLoading
                    ? const SizedBox(
                        width: AppConfig.iconSm,
                        height: AppConfig.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.equalizer_rounded,
                        color: Colors.white,
                        size: AppConfig.iconSm,
                      ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArtworkPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.radio,
        size: AppConfig.iconMd,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, S l10n) {
    final theme = Theme.of(context);
    final station = state.currentStation!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Station name
        Text(
          station.name,
          style: theme.textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 2),

        // Status
        Text(
          state.error != null
              ? l10n.error
              : state.isLoading
                  ? l10n.loadingStation
                  : state.isPlaying
                      ? l10n.playing
                      : l10n.paused,
          style: theme.textTheme.bodySmall?.copyWith(
            color: state.error != null
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, WidgetRef ref, S l10n) {
    final theme = Theme.of(context);
    final station = state.currentStation!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Share
        IconButton(
          onPressed: () async {
            unawaited(Haptics.light());
            await SharePlus.instance.share(
              ShareParams(
                text: l10n.shareMessage(
                  station.name,
                  '${AppConfig.deepLinkBaseUrl}/station/${station.stationUuid}',
                ),
              ),
            );
          },
          tooltip: l10n.shareButtonLabel,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.share_outlined,
            size: AppConfig.iconSm,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // Play/Pause/Retry
        if (state.isLoading)
          const SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (state.error != null)
          IconButton(
            onPressed: () async {
              unawaited(Haptics.light());
              await ref.read(audioPlayerProvider.notifier).playStation(station);
            },
            tooltip: l10n.retryButtonLabel,
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.primary,
            ),
          )
        else
          IconButton(
            onPressed: () async {
              unawaited(Haptics.light());
              await ref.read(audioPlayerProvider.notifier).togglePlayPause();
            },
            tooltip:
                state.isPlaying ? l10n.pauseButtonLabel : l10n.playButtonLabel,
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppConfig.radiusMd),
              ),
              child: Icon(
                state.isPlaying ? Icons.pause : Icons.play_arrow,
                color: theme.colorScheme.onPrimary,
                size: AppConfig.iconMd,
              ),
            ),
          ),

        // Close
        IconButton(
          onPressed: () async {
            unawaited(Haptics.light());
            await ref.read(audioPlayerProvider.notifier).stop();
          },
          tooltip: l10n.stopButtonLabel,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.close,
            size: AppConfig.iconSm,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
