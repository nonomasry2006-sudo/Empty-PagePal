import 'package:flutter/material.dart';

class ReadingTimerScreen extends StatelessWidget {
  const ReadingTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading Session')),
      body: const Center(
        child: Text('Timer, notes and stats will live here.'),
      ),
    );
  }
}
