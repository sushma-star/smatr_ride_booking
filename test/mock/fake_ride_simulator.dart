import 'package:smart_ridebooking/models/trip_model.dart';
import 'package:smart_ridebooking/services/ride_simulator.dart';

class FakeRideSimulator implements RideSimulator {
  @override
  Future<void> simulate(Trip trip, void Function(Trip) callback) async {
     callback(trip.copyWith(status: trip.status));
  }
}
