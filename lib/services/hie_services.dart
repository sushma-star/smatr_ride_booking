import 'package:hive/hive.dart';
import '../models/trip_model.dart';
import '../models/ride_type.dart';

class HiveService {
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RideStatusAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RideTypeAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TripAdapter());
    }
  }

  static Box<Trip> tripBox() => Hive.box<Trip>('trips');
}
