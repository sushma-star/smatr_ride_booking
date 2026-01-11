import 'package:flutter/material.dart';

class DriverTracker extends StatelessWidget {
  final double progress;
  const DriverTracker({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: progress);
  }
}
