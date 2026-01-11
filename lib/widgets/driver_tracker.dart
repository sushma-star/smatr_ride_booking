import 'package:flutter/material.dart';

class DriverTracker extends StatelessWidget {
  final double progress;

  const DriverTracker({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 6),
        Text(
          'Driver en route',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
