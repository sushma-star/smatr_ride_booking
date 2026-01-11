
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
 import '../../provider/theme_provider.dart';
import '../../provider/budget_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../models/trip_model.dart';
import '../../provider/trip_provider.dart';
import '../../utils/csv_export.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final trips = data['completedTrips'] as List<Trip>? ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(budgetProvider.notifier).updateFromTrips(trips);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book a Ride',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () =>
                ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Ride',),
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
            _heroStats(context, data),
            const SizedBox(height: 12),
            _glassCard(context, TripChart(trips: trips)),
            if (budget.isLimitExceeded) _budgetGlass(context),
            const SizedBox(height: 10),
            const MonthlyBudgetCard(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Recent Rides',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    final trips = ref.read(tripProvider);
                    exportTrips(context,trips);
                  },
                ),

              ],
            ),
            const TripListScreen(),
          ],
        ),
      ),
    );
  }

  Widget _heroStats(BuildContext context, Map data) {
    return Row(
      children: [
        _stat(context, 'Trips', data['totalTrips'] ?? 0),
        const SizedBox(width: 12),
        _stat(context, 'Spent', data['totalAmount']?.toInt() ?? 0,
            money: true),
      ],
    );
  }

  Widget _stat(BuildContext context, String t, int v,
      {bool money = false}) {
    final card = Theme.of(context).cardColor;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(t),
            const SizedBox(height: 6),
            Text(
              money ? '₹$v' : '$v',
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard(BuildContext context, Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _budgetGlass(BuildContext context) {
    return _glassCard(
      context,
      Row(
        children: const [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(child: Text('Monthly budget exceeded')),
        ],
      ),
    );
  }
}
