import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Ride Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}
