import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/storage/prefs_service.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const List<Map<String, String>> _pages = [
    {
      'lottie': 'assets/lottie/onboarding1.json',
      'title': 'Your reading grove',
      'subtitle':
          'Plant every book on your shelves — Want to Read, Reading, Finished.',
    },
    {
      'lottie': 'assets/lottie/onboarding2.json',
      'title': 'Mark the moments',
      'subtitle': 'Add notes that bloom beside the pages you love.',
    },
    {
      'lottie': 'assets/lottie/onboarding3.json',
      'title': 'Wander the shelves',
      'subtitle': 'Explore millions of titles waiting to be discovered.',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await PrefsService.setOnboardingSeen(true);
    if (mounted) {
      context.go(RouteNames.login);
    }
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        showFireflies: true,
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar with Skip
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedOpacity(
                      opacity: isLastPage ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        onPressed: isLastPage ? null : _skip,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── PageView
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return OnboardingPage(
                      lottiePath: page['lottie']!,
                      title: page['title']!,
                      subtitle: page['subtitle']!,
                    );
                  },
                ),
              ),

              // ── Bottom section: dots + button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                child: Column(
                  children: [
                    // Dots
                    DotsIndicator(
                      count: _pages.length,
                      currentIndex: _currentPage,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: Colors.white.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 32),

                    // Next / Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isLastPage
                            ? _buildGlowButton(
                                key: const ValueKey('start'),
                                label: 'Get Started',
                                onTap: _next,
                                theme: theme,
                              )
                            : _buildNextButton(
                                key: const ValueKey('next'),
                                onTap: _next,
                                theme: theme,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton({
    required Key key,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return OutlinedButton(
      key: key,
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Next',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildGlowButton({
    required Key key,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 6),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: theme.colorScheme.secondary.withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: -8,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}