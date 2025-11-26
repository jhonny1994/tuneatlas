import 'package:flutter/material.dart';
import 'package:tuneatlas/src/src.dart';

/// Data model for onboarding pages
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

/// Predefined onboarding pages
class OnboardingPages {
  static List<OnboardingPageData> pages(BuildContext context) {
    final l10n = S.of(context);
    return [
      OnboardingPageData(
        title: l10n.welcomeTitle,
        description: l10n.welcomeDescription,
        icon: Icons.radio,
        color: const Color(0xFF6200EE),
      ),
      OnboardingPageData(
        title: l10n.exploreTitle,
        description: l10n.exploreDescription,
        icon: Icons.public,
        color: const Color(0xFF03DAC6),
      ),
      OnboardingPageData(
        title: l10n.favoritesTitle,
        description: l10n.favoritesDescription,
        icon: Icons.favorite,
        color: const Color(0xFFBB86FC),
      ),
    ];
  }
}
