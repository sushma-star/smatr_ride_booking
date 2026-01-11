import 'package:flutter/material.dart';

class AnimatedFare extends StatelessWidget {
  final double fare;
  const AnimatedFare({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        '₹${fare.toStringAsFixed(2)}',
        key: ValueKey(fare),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
