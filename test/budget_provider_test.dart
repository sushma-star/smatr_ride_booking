 import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ridebooking/models/ride_type.dart';
import 'package:smart_ridebooking/models/trip_model.dart';
import 'package:smart_ridebooking/provider/budget_provider.dart';

void main() {
  late ProviderContainer container;
  late BudgetNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(budgetProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('initial state has correct limits', () {
    final state = container.read(budgetProvider);
    expect(state.limits[RideType.mini], 5000);
    expect(state.limits[RideType.sedan], 8000);
    expect(state.totalSpent, 0);
    expect(state.isLimitExceededFor(RideType.mini), false);
  });

  test('addExpense updates spent correctly', () {
    notifier.addExpense(RideType.mini, 1000);
    var state = container.read(budgetProvider);
    expect(state.spent[RideType.mini], 1000);
    expect(state.isLimitExceededFor(RideType.mini), false);

    notifier.addExpense(RideType.mini, 5000);
    state = container.read(budgetProvider);
    expect(state.spent[RideType.mini], 6000);
    expect(state.isLimitExceededFor(RideType.mini), true);
  });

  test('updateFromTrips calculates spent for current month', () {
    final now = DateTime.now();
    final trips = [
      Trip(
        id: '1',
        rideType: RideType.mini,
        fare: 2000,
        dateTime: now,
        status: RideStatus.completed,
        pickup: 'pick A',
        drop: ' pick B',
      ),
      Trip(
        id: '2',
        rideType: RideType.sedan,
        fare: 3000,
        dateTime: now,
        status: RideStatus.completed,
        pickup: 'Old A',
        drop: ' Old B',
      ),
      Trip(
        id: '3',
        rideType: RideType.mini,
        fare: 500,
        dateTime: DateTime(now.year, now.month - 1, now.day),
        status: RideStatus.completed,
        pickup: 'near A',
        drop: ' near B',
      ),
    ];

    notifier.updateFromTrips(trips);
    final state = container.read(budgetProvider);
    expect(state.spent[RideType.mini], 2000);
    expect(state.spent[RideType.sedan], 3000);
    expect(state.spent.containsKey(RideType.auto), false);
  });
}
