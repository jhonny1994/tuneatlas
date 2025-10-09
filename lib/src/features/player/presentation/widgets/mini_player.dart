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
    final station = state.currentStation!;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Station artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: station.favicon.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: station.favicon,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 56,
                        height: 56,
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.radio,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 56,
                        height: 56,
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.radio,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHigh,
                      child: Icon(
                        Icons.radio,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

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
                      if (state.isLoading)
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
                          state.isPlaying ? Icons.play_arrow : Icons.pause,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          state.isLoading
                              ? 'Loading...'
                              : (state.isPlaying ? 'Playing' : 'Paused'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
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
            else
              IconButton(
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () =>
                    ref.read(audioPlayerProvider.notifier).togglePlayPause(),
              ),

            // Stop button
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(audioPlayerProvider.notifier).stop(),
            ),
          ],
        ),
      ),
    );
  }
}
