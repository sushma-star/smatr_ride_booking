import '../models/trip_model.dart';
class RideSimulator {
  Future<void> simulate(Trip trip, void Function(Trip) onUpdate) async {
    var updatedTrip = trip.copyWith(status: RideStatus.requested);
    onUpdate(updatedTrip);

    await Future.delayed(Duration(seconds: 2));
    updatedTrip = updatedTrip.copyWith(status: RideStatus.driverAssigned);
    onUpdate(updatedTrip);

    await Future.delayed(Duration(seconds: 2));
    updatedTrip = updatedTrip.copyWith(status: RideStatus.started);
    onUpdate(updatedTrip);

    await Future.delayed(Duration(seconds: 4));
    updatedTrip = updatedTrip.copyWith(status: RideStatus.completed);
    onUpdate(updatedTrip);
  }
}


