
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:smart_ridebooking/models/trip_model.dart';
import 'package:smart_ridebooking/models/ride_type.dart';

class HiveService {
  static late Box<Trip> _tripBox;

  static Box<Trip> tripBox() => _tripBox;
}

 Future<void> initHiveMocks() async {
  await setUpTestHive();

   if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(RideStatusAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(RideTypeAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TripAdapter());

  HiveService._tripBox = await Hive.openBox<Trip>('trips');
}

 Future<void> tearDownHiveMocks() async {
  await tearDownTestHive();
}
