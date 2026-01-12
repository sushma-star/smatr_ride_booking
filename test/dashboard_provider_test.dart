
 import 'package:flutter_test/flutter_test.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ridebooking/models/ride_type.dart';
import 'package:smart_ridebooking/models/trip_model.dart';
import 'package:smart_ridebooking/provider/dashboard_provider.dart';
import 'package:smart_ridebooking/provider/trip_provider.dart';

import 'mock/fake_ride_simulator.dart';
import 'mock/hive_mock.dart';




void main() async {
  await initHiveMocks();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        tripProvider.overrideWith(
              (ref) => TripNotifier(ref, simulator: FakeRideSimulator()),
        ),
      ],
    );
  });

  tearDown(() async {
    await HiveService.tripBox().clear();
    container.dispose();
  });

  test('dashboardProvider returns correct stats', () async {
    final tripNotifier = container.read(tripProvider.notifier);

    final trips = [
      Trip(
        id: '1',
        pickup: 'A',
        drop: 'B',
        rideType: RideType.mini,
        fare: 100,
        status: RideStatus.completed,
        dateTime: DateTime.now(),
      ),
      Trip(
        id: '2',
        pickup: 'C',
        drop: 'D',
        rideType: RideType.sedan,
        fare: 200,
        status: RideStatus.completed,
        dateTime: DateTime.now(),
      ),
    ];

    for (var t in trips) {
      await tripNotifier.addTrip(t);
    }

    final dashboard = container.read(dashboardProvider);
    expect(dashboard['totalTrips'], 2);
    expect(dashboard['totalAmount'], 300);
  });
}


