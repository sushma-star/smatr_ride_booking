import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/trip_provider.dart';
import 'trip_tile.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripProvider);
    final sortedTrips = [...trips]..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (sortedTrips.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No trips booked yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        sortedTrips.length,
            (index) => TripTile(trip: sortedTrips[index], index: index),
      ),
    );
  }
}
