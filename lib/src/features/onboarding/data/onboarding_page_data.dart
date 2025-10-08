import 'package:flutter/material.dart';

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
  static const pages = [
    OnboardingPageData(
      title: 'Discover Radio Stations',
      description:
          'Access thousands of radio stations from around the world. Find your favorite music, news, and talk shows.',
      icon: Icons.radio,
      color: Color(0xFF6200EE),
    ),
    OnboardingPageData(
      title: 'Browse by Country',
      description:
          'Explore local and international stations. Filter by country, language, or genre to find what you love.',
      icon: Icons.public,
      color: Color(0xFF03DAC6),
    ),
    OnboardingPageData(
      title: 'Save Your Favorites',
      description:
          'Create your personal library of favorite stations. Quick access to the stations you listen to most.',
      icon: Icons.favorite,
      color: Color(0xFFBB86FC),
    ),
  ];
}
