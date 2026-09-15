import 'package:flutter/material.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({super.key, this.minutes = 25});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: CircularProgressIndicator(
        value: 0.7,
        strokeWidth: 12,
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
