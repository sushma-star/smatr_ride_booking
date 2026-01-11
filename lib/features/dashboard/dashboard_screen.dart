import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/trip_model.dart';
import '../../provider/trip_provider.dart';
 import '../trips/add_trip_screen.dart';
import '../trips/trip_list_screen.dart';
import 'trip_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final trips = ref.watch(tripProvider);

     final completedTrips =
    trips.where((t) => t.status == RideStatus.completed).toList();

    final totalTrips = trips.length;

    final totalAmount = completedTrips.fold<int>(
      0,
          (sum, t) => sum + t.fare.toInt(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: const Text(
          'Book a Ride',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.black54,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Ride',
          style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTripScreen()),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroStats(
              totalTrips: totalTrips,
              totalAmount: totalAmount,
            ),

            const SizedBox(height: 28),

            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ride Analytics',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TripChart(trips: completedTrips),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Rides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 8),
            const TripListScreen(),
          ],
        ),
      ),
    );
  }


  Widget _heroStats({
    required int totalTrips,
    required int totalAmount,
  }) {
    return Row(
      children: [
        Expanded(
          child: _statGlass(
            title: 'Trips',
            value: totalTrips,
            icon: Icons.directions_car,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statGlass(
            title: 'Spent',
            value: totalAmount,
            icon: Icons.currency_rupee,
            isMoney: true,
          ),
        ),
      ],
    );
  }

  Widget _statGlass({
    required String title,
    required int value,
    required IconData icon,
    bool isMoney = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.12),
                child: Icon(icon, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 800),
            builder: (_, v, __) => Text(
              isMoney ? '₹$v' : '$v',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
