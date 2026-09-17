import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('PagePal'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good evening, Reader',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _StatCard(label: 'Books Read', value: '14'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(label: 'Streak', value: '12d'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Currently reading',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const _PlaceholderReadingCard(),
                const SizedBox(height: 24),
                Text(
                  'Your shelves',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const _ShelfTile(label: 'Want to Read', count: '28 books'),
                const SizedBox(height: 10),
                const _ShelfTile(label: 'Reading Now', count: '2 books'),
                const SizedBox(height: 10),
                const _ShelfTile(label: 'Finished', count: '14 books'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class _PlaceholderReadingCard extends StatelessWidget {
  const _PlaceholderReadingCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: const Icon(Icons.auto_stories_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Midnight Library',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Matt Haig',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                const LinearProgressIndicator(
                  value: 0.72,
                  minHeight: 6,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelfTile extends StatelessWidget {
  final String label;
  final String count;
  const _ShelfTile({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(count, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}