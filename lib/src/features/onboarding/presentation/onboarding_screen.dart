import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuneatlas/src/src.dart';

/// Onboarding screen shown on first launch
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingStateProvider.notifier).complete();
    if (mounted) {
      final pendingLink = ref.read(pendingDeepLinkProvider);
      if (pendingLink != null) {
        ref.read(pendingDeepLinkProvider.notifier).clear();
        context.go(pendingLink);
      } else {
        context.go('/home');
      }
    }
  }

  Future<void> _skipToEnd() async {
    await _pageController.animateToPage(
      OnboardingPages.pages(context).length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _nextPage() async {
    if (_currentPage < OnboardingPages.pages(context).length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);
    final isLastPage =
        _currentPage == OnboardingPages.pages(context).length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (!isLastPage)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () async {
                    unawaited(Haptics.light());
                    await _skipToEnd();
                  },
                  child: Text(l10n.skip),
                ),
              )
            else
              const SizedBox(height: AppConfig.buttonHeightLg),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingPages.pages(context).length,
                itemBuilder: (context, index) {
                  final page = OnboardingPages.pages(context)[index];
                  return _OnboardingPage(page: page);
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                OnboardingPages.pages(context).length,
                (index) => _PageIndicator(
                  isActive: index == _currentPage,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppConfig.spacingXL),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConfig.paddingContent,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppConfig.buttonHeightLg,
                child: FilledButton(
                  onPressed: () async {
                    unawaited(Haptics.light());
                    await _nextPage();
                  },
                  child: Text(isLastPage ? l10n.getStarted : l10n.next),
                ),
              ),
            ),
            const SizedBox(height: AppConfig.spacingXL),
          ],
        ),
      ),
    );
  }
}

/// Individual onboarding page
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppConfig.paddingContent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: AppConfig.onboardingIconContainerSize,
            height: AppConfig.onboardingIconContainerSize,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: AppConfig.onboardingIconSize,
              color: page.color,
            ),
          ),
          const SizedBox(height: AppConfig.spacingXXL),

          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.spacingM),

          // Description
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Page indicator dot
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.isActive,
    required this.color,
  });

  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConfig.durationNormal,
      margin: const EdgeInsets.symmetric(horizontal: AppConfig.spacingXS),
      width: isActive ? AppConfig.spacingL : AppConfig.spacingS,
      height: AppConfig.spacingS,
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConfig.radiusSm),
      ),
    );
  }
}
