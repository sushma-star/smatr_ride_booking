import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_model.dart';
import '../services/hie_services.dart';
import '../services/ride_simulator.dart';
 import 'budget_provider.dart';
final tripProvider =
StateNotifierProvider<TripNotifier, List<Trip>>(
      (ref) => TripNotifier(ref),
);

class TripNotifier extends StateNotifier<List<Trip>> {
  final Ref ref;
  final RideSimulator simulator;

   void Function(String message)? showMessage;

  TripNotifier(
      this.ref, {
        RideSimulator? simulator,
      })  : simulator = simulator ?? RideSimulator(),
        super(HiveService.tripBox().values.toList());

   Future<void> addTrip(Trip trip) async {
    await HiveService.tripBox().put(trip.id, trip);

    if (mounted) {
      state = [...state, trip];
    }

     simulator.simulate(trip, (updatedTrip) async {
      if (!mounted) return;

      await HiveService.tripBox().put(updatedTrip.id, updatedTrip);

      if (mounted) {
        state = [
          for (final t in state)
            if (t.id == updatedTrip.id) updatedTrip else t
        ];
      }

      _handleCompletion(updatedTrip);
      _notifyStatus(updatedTrip.status);
    });
  }

   Future<void> updateTrip(Trip updatedTrip) async {
    await HiveService.tripBox().put(updatedTrip.id, updatedTrip);

    _handleCompletion(updatedTrip);
    _notifyStatus(updatedTrip.status);

    if (mounted) {
      state = [
        for (final t in state)
          if (t.id == updatedTrip.id) updatedTrip else t
      ];
    }
  }

   Future<void> updateStatus(String id, RideStatus status) async {
    final oldTrip = state.firstWhere((t) => t.id == id);
    final updatedTrip = oldTrip.copyWith(status: status);

    await HiveService.tripBox().put(id, updatedTrip);

    _handleCompletion(updatedTrip);
    _notifyStatus(updatedTrip.status);

    if (mounted) {
      state = [
        for (final t in state)
          if (t.id == id) updatedTrip else t
      ];
    }
  }

   Future<void> deleteTrip(String id) async {
    await HiveService.tripBox().delete(id);
    if (mounted) {
      state = state.where((t) => t.id != id).toList();
    }
  }

   void _handleCompletion(Trip trip) {
    if (trip.status == RideStatus.completed) {
      ref.read(budgetProvider.notifier).addExpense(
        trip.rideType,
        trip.fare,
      );
    }
  }

   void _notifyStatus(RideStatus status) {
    if (showMessage == null) return;

    String message = '';
    switch (status) {
      case RideStatus.requested:
        message = 'Ride Requested';
        break;
      case RideStatus.driverAssigned:
        message = 'Driver Assigned 🚗';
        break;
      case RideStatus.started:
        message = 'Ride Started';
        break;
      case RideStatus.completed:
        message = 'Ride Completed ✅';
        break;
      case RideStatus.cancelled:
        message = 'Ride Cancelled';
        break;
    }

    showMessage!(message);
  }
}


