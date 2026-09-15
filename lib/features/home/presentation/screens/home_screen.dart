import 'package:flutter/material.dart';

import '../../../core/widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good evening, Jana',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: _StatCard(label: 'Books Read', value: '14')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Streak', value: '12d')),
              ],
            ),
            const SizedBox(height: 24),
            Text('Currently reading', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  BookCard(
                    title: 'The Midnight Library',
                    author: 'Matt Haig',
                    coverUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=600&q=80',
                    progress: 0.72,
                  ),
                  SizedBox(width: 12),
                  BookCard(
                    title: 'Atomic Habits',
                    author: 'James Clear',
                    coverUrl: 'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=600&q=80',
                    progress: 0.48,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Your shelves', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _ShelfTile(label: 'Want to Read', count: '28 books'),
            _ShelfTile(label: 'Reading Now', count: '2 books'),
            _ShelfTile(label: 'Finished', count: '14 books'),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _ShelfTile extends StatelessWidget {
  const _ShelfTile({required this.label, required this.count});

  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(count, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
