import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Persistent banner that shows when device is offline
class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStream = ref.watch(networkMonitorProvider);

    return networkStream.when(
      data: (status) {
        if (status == NetworkStatus.offline) {
          return _buildOfflineBanner(context);
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildOfflineBanner(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Material(
      color: theme.colorScheme.errorContainer,
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 20,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.noInternetConnection,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.info_outline,
              size: 18,
              color: theme.colorScheme.onErrorContainer.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
