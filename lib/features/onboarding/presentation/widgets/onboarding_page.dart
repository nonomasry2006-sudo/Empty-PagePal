import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  final String lottiePath;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.lottiePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          SizedBox(
            width: 280,
            height: 280,
            child: Lottie.asset(
              lottiePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.auto_stories_rounded,
                  size: 120,
                  color: theme.colorScheme.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}