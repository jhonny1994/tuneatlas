import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);

    return audioState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (state) {
        // Only show mini player if there's an active station
        if (state.currentStation == null || state.isStopped) {
          return const SizedBox.shrink();
        }

        return _buildMiniPlayer(context, ref, state);
      },
    );
  }

  Widget _buildMiniPlayer(
    BuildContext context,
    WidgetRef ref,
    AudioState state,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final station = state.currentStation!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        boxShadow: [
          // Primary shadow - more pronounced
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: 0.3,
            ), // Enhanced from 0.2
            blurRadius: 16, // Enhanced from 8
            offset: const Offset(0, -4), // Enhanced from -2
          ),
          // Secondary shadow for depth
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error banner (if error exists)
          if (state.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConfig.paddingScreen,
                vertical: AppConfig.spacingS,
              ),
              color: theme.colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: AppConfig.spacingS),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        ref.read(audioPlayerProvider.notifier).stop(),
                  ),
                ],
              ),
            ),
          // Main player controls
          SizedBox(
            height: AppConfig.miniPlayerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConfig.paddingScreen,
                vertical: AppConfig.spacingS,
              ),
              child: Row(
                children: [
                  // Station artwork with glow when playing
                  Container(
                    decoration: state.isPlaying
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConfig.radiusImage,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          )
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConfig.radiusImage,
                      ),
                      child: station.favicon.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: station.favicon,
                              width: AppConfig.miniPlayerImageSize,
                              height: AppConfig.miniPlayerImageSize,
                              fit: BoxFit.cover,
                              memCacheHeight: 112, // 2x for high DPI displays
                              maxHeightDiskCache: 168, // Limit disk cache size
                              placeholder: (context, url) => Container(
                                width: AppConfig.miniPlayerImageSize,
                                height: AppConfig.miniPlayerImageSize,
                                color: theme.colorScheme.surfaceContainerHigh,
                                child: Icon(
                                  Icons.radio,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: AppConfig.miniPlayerImageSize,
                                height: AppConfig.miniPlayerImageSize,
                                color: theme.colorScheme.surfaceContainerHigh,
                                child: Icon(
                                  Icons.radio,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                          : Container(
                              width: AppConfig.miniPlayerImageSize,
                              height: AppConfig.miniPlayerImageSize,
                              color: theme.colorScheme.surfaceContainerHigh,
                              child: Icon(
                                Icons.radio,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: AppConfig.spacingM),

                  // Station info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          station.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (state.error != null)
                              Icon(
                                Icons.error,
                                size: 12,
                                color: theme.colorScheme.error,
                              )
                            else if (state.isLoading)
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            else
                              Icon(
                                state.isPlaying
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                state.error != null
                                    ? AudioErrorMapper.getLocalizedError(
                                        context,
                                        state.error!,
                                      )
                                    : (state.isLoading
                                        ? l10n.loadingStation
                                        : (state.isPlaying
                                            ? l10n.playing
                                            : l10n.paused)),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: state.error != null
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Play/pause button
                  if (state.isLoading)
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else if (state.error != null)
                    // Show retry button on error
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        unawaited(Haptics.light());
                        await ref
                            .read(audioPlayerProvider.notifier)
                            .playStation(station);
                      },
                    )
                  else
                    IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        unawaited(Haptics.light());
                        await ref
                            .read(audioPlayerProvider.notifier)
                            .togglePlayPause();
                      },
                    ),

                  // Stop button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      unawaited(Haptics.light());
                      await ref.read(audioPlayerProvider.notifier).stop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
