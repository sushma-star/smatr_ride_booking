
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip_model.dart';
 import '../services/hie_services.dart';
import '../services/ride_simulator.dart';

final tripProvider = StateNotifierProvider<TripNotifier, List<Trip>>(
      (ref) => TripNotifier(),
);

class TripNotifier extends StateNotifier<List<Trip>> {
  TripNotifier() : super(HiveService.tripBox().values.toList());

  void addTrip(Trip trip) {
    HiveService.tripBox().put(trip.id, trip);
    state = [...state, trip];

     RideSimulator().simulate(trip, (updatedTrip) async {
       await HiveService.tripBox().put(updatedTrip.id, updatedTrip);

       state = [
        for (final t in state)
          if (t.id == updatedTrip.id) updatedTrip else t
      ];
    });
  }
  void updateTrip(Trip updatedTrip) {
    state = state.map((trip) {
      return trip.id == updatedTrip.id ? updatedTrip : trip;
    }).toList();
  }

   void updateStatus(String id, RideStatus status) {
    state = state.map((trip) {
      if (trip.id == id) {
        return trip.copyWith(status: status);
      }
      return trip;
    }).toList();
  }
  void deleteTrip(String id) {
    HiveService.tripBox().delete(id);
    state = state.where((t) => t.id != id).toList();
  }
}
