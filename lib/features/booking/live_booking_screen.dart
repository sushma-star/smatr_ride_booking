import 'package:flutter/material.dart';
import '../../widgets/animated_fare.dart';
import '../../widgets/driver_tracker.dart';

class LiveBookingScreen extends StatefulWidget {
  const LiveBookingScreen({super.key});

  @override
  State<LiveBookingScreen> createState() => _LiveBookingScreenState();
}

class _LiveBookingScreenState extends State<LiveBookingScreen> {
  double fare = 100;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        fare += 5;
        progress += 0.1;
      });
      return progress < 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Ride')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedFare(fare: fare),
          const SizedBox(height: 16),
          DriverTracker(progress: progress),
        ],
      ),
    );
  }
}
