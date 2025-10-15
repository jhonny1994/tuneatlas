import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuneatlas/src/src.dart';

/// Language switcher button for AppBar
/// Dynamically displays all languages from SupportedLanguages configuration
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentLanguage = ref.watch(currentLanguageProvider);
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(
        Icons.language,
        color: theme.colorScheme.onSurface,
      ),
      tooltip: currentLanguage.nativeName,
      onPressed: () {
        unawaited(Haptics.light());
        _showLanguageDialog(context, ref, currentLocale);
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    unawaited(
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.language),
          content: SizedBox(
            width: double.maxFinite,
            child: RadioGroup<String>(
              groupValue: currentLocale.languageCode,
              onChanged: (value) async {
                if (value != null && value != currentLocale.languageCode) {
                  unawaited(Haptics.toggle());
                  await ref.read(localeProvider.notifier).setLocale(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: ListView(
                shrinkWrap: true,
                children: SupportedLanguages.all.map((language) {
                  return RadioListTile<String>(
                    value: language.locale,
                    title: Text(
                      language.nativeName,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            FilledButton.tonal(
              onPressed: () {
                unawaited(Haptics.light());
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
