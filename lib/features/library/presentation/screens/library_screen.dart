import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Library'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          tabs: const [
            Tab(text: 'Reading'),
            Tab(text: 'Want'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _ShelfList(),
              _ShelfList(),
              _ShelfList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShelfList extends StatelessWidget {
  const _ShelfList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => GlassCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary
                    .withValues(alpha: 0.25),
              ),
              child: const Icon(Icons.book_outlined),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shelf Book ${i + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 5,
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}