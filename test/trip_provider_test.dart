import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ridebooking/models/ride_type.dart';
import 'package:smart_ridebooking/models/trip_model.dart';
import 'package:smart_ridebooking/provider/budget_provider.dart';
import 'package:smart_ridebooking/provider/trip_provider.dart';

import 'mock/fake_ride_simulator.dart';
import 'mock/hive_mock.dart';

void main() async {
  await initHiveMocks();

  late ProviderContainer container;
  late TripNotifier tripNotifier;
  late BudgetNotifier budgetNotifier;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        tripProvider.overrideWith(
              (ref) => TripNotifier(ref, simulator: FakeRideSimulator()),
        ),
      ],
    );

     tripNotifier = container.read(tripProvider.notifier);
    budgetNotifier = container.read(budgetProvider.notifier);
  });

  tearDown(() async {
    await HiveService.tripBox().clear();
    container.dispose();
  });

  test('addTrip writes Trip with RideType correctly', () async {
    final trip = Trip(
      id: '1',
      pickup: 'A',
      drop: 'B',
      rideType: RideType.mini,
      fare: 150,
      status: RideStatus.completed,
      dateTime: DateTime.now(),
    );

    await tripNotifier.addTrip(trip);

    final stored = HiveService.tripBox().get('1');
    expect(stored, isNotNull);
    expect(stored!.rideType, RideType.mini);
  });

  test('updateStatus updates trip and adds to budget on completion', () async {
    final trip = Trip(
      id: '2',
      pickup: 'X',
      drop: 'Y',
      rideType: RideType.sedan,
      fare: 300,
      status: RideStatus.started,
      dateTime: DateTime.now(),
    );

    await tripNotifier.addTrip(trip);

     await tripNotifier.updateStatus('2', RideStatus.completed);

    final updatedTrip = HiveService.tripBox().get('2');
    expect(updatedTrip!.status, RideStatus.completed);

    final budget = container.read(budgetProvider);
    expect(budget.spent[RideType.sedan], 300);
  });
}
