import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'trip_provider.dart';
import '../models/trip_model.dart';

final dashboardProvider = Provider((ref) {
  final trips = ref.watch(tripProvider);
  final completed =
  trips.where((t) => t.status == RideStatus.completed);

  return {
    'totalTrips': completed.length,
    'totalAmount':
    completed.fold<double>(0, (s, t) => s + t.fare),
    'completedTrips': completed.toList(),
  };
});
