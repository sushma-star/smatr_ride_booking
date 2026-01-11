

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
    final theme = Theme.of(context);

    if (sortedTrips.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No trips booked yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
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
