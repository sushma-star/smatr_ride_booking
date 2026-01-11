import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_model.dart';
import '../services/hie_services.dart';
import '../services/ride_simulator.dart';
import '../utils/notifications_services.dart';
import 'budget_provider.dart';

final tripProvider =
StateNotifierProvider<TripNotifier, List<Trip>>(
      (ref) => TripNotifier(ref),
);

class TripNotifier extends StateNotifier<List<Trip>> {
  final Ref ref;

  TripNotifier(this.ref)
      : super(HiveService.tripBox().values.toList());

  // ---------------- ADD TRIP ----------------
  Future<void> addTrip(Trip trip) async {
    await HiveService.tripBox().put(trip.id, trip);
    state = [...state, trip];

    _notifyIfChanged(null, trip.status);

    // simulate ride lifecycle
    RideSimulator().simulate(trip, (updatedTrip) async {
      final oldTrip =
      state.firstWhere((t) => t.id == updatedTrip.id);

      await HiveService.tripBox()
          .put(updatedTrip.id, updatedTrip);

      _handleCompletion(updatedTrip);
      _notifyIfChanged(oldTrip.status, updatedTrip.status);

      state = [
        for (final t in state)
          if (t.id == updatedTrip.id) updatedTrip else t
      ];
    });
  }

  // ---------------- UPDATE TRIP ----------------
  Future<void> updateTrip(Trip updatedTrip) async {
    final oldTrip =
    state.firstWhere((t) => t.id == updatedTrip.id);

    await HiveService.tripBox()
        .put(updatedTrip.id, updatedTrip);

    _handleCompletion(updatedTrip);
    _notifyIfChanged(oldTrip.status, updatedTrip.status);

    state = [
      for (final t in state)
        if (t.id == updatedTrip.id) updatedTrip else t
    ];
  }

  // ---------------- UPDATE STATUS ----------------
  Future<void> updateStatus(String id, RideStatus status) async {
    final oldTrip = state.firstWhere((t) => t.id == id);
    final updatedTrip = oldTrip.copyWith(status: status);

    await HiveService.tripBox().put(id, updatedTrip);

    _handleCompletion(updatedTrip);
    _notifyIfChanged(oldTrip.status, status);

    state = [
      for (final t in state)
        if (t.id == id) updatedTrip else t
    ];
  }

  // ---------------- DELETE ----------------
  Future<void> deleteTrip(String id) async {
    await HiveService.tripBox().delete(id);
    state = state.where((t) => t.id != id).toList();
  }

  // ---------------- BUDGET HANDLING ----------------
  void _handleCompletion(Trip trip) {
    if (trip.status == RideStatus.completed) {
      ref.read(budgetProvider.notifier).addExpense(
        trip.rideType,
        trip.fare,
      );
    }
  }

  // ---------------- SAFE NOTIFICATION ----------------
  void _notifyIfChanged(
      RideStatus? oldStatus, RideStatus newStatus) {
    if (oldStatus == newStatus) return; // 🚫 STOP duplicates

    switch (newStatus) {
      case RideStatus.requested:
        NotificationService.show(
          title: 'Ride Requested',
          body: 'Your ride has been booked successfully',
        );
        break;

      case RideStatus.driverAssigned:
        NotificationService.show(
          title: 'Driver Assigned 🚗',
          body: 'Your driver is on the way',
        );
        break;

      case RideStatus.started:
        NotificationService.show(
          title: 'Ride Started',
          body: 'Enjoy your journey',
        );
        break;

      case RideStatus.completed:
        NotificationService.show(
          title: 'Ride Completed ✅',
          body: 'Thanks for riding with us',
        );
        break;

      case RideStatus.cancelled:
        NotificationService.show(
          title: 'Ride Cancelled',
          body: 'Your ride has been cancelled',
        );
        break;
    }
  }
}
