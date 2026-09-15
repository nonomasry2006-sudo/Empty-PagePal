import 'package:flutter/material.dart';

class ShelfTabBar extends StatelessWidget {
  const ShelfTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Chip(label: Text('Reading')),
        SizedBox(width: 8),
        Chip(label: Text('Want to Read')),
        SizedBox(width: 8),
        Chip(label: Text('Finished')),
      ],
    );
  }
}
