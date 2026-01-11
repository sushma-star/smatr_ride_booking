
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/trip_model.dart';

import '../../provider/budget_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../widgets/monthly_budget_card.dart';
import '../trips/add_trip_screen.dart';
import '../trips/trip_list_screen.dart';
import 'trip_chart.dart';



class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final budget = ref.watch(budgetProvider);

     final trips = data['completedTrips'] as List<Trip>? ?? [];

     WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(budgetProvider.notifier).updateFromTrips(trips);
    });

    return Scaffold(
      backgroundColor:Color(0xFFF3F3F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Book a Ride',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color:  Colors.black54,
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
        elevation: 10,
        icon: const Icon(Icons.add, color:  Colors.white),
        label: const Text(
          'New Ride',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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

            _heroStats(data),

            const SizedBox(height: 10),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ride Analytics',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black54
                    ),
                  ),
                  const SizedBox(height: 7),
                  TripChart(trips: trips),
                ],
              ),
            ),


            if (budget.isLimitExceeded) _budgetGlass(),

            const SizedBox(height: 10),
            MonthlyBudgetCard(),

            const Text(
              'Recent Rides',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color:  Colors.black54
              ),
            ),
            const SizedBox(height: 5),



            const TripListScreen(),
          ],
        ),
      ),
    );
  }

  Widget _heroStats(Map data) {
    return Row(
      children: [
        Expanded(
          child: _statGlass(
            title: 'Trips',
            value: data['totalTrips'] ?? 0,
            icon: Icons.directions_car,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statGlass(
            title: 'Spent',
            value: (data['totalAmount'] as num?)?.toInt() ?? 0,
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment. center,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 20),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),



          const SizedBox(height: 4),

          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 800),
            builder: (_, v, __) => Text(
              isMoney ? '₹$v' : '$v',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
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
            color: Colors.white ,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
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

  Widget _budgetGlass() {
    return _glassCard(
      child: Row(
        children: const [
          Icon(Icons.warning_rounded, color: Colors.yellow),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are over your monthly ride budget',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
