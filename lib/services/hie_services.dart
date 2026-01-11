import 'package:hive/hive.dart';
import '../models/trip_model.dart';
import '../models/ride_type.dart';

class HiveService {
  static Future<void> init() async {
    Hive.registerAdapter(TripAdapter());
    Hive.registerAdapter(RideStatusAdapter());
    Hive.registerAdapter(RideTypeAdapter());
  }

  static Box<Trip> tripBox() => Hive.box<Trip>('trips');
}
