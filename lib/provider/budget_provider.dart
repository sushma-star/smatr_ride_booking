import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ride_type.dart';
import '../models/trip_model.dart';
import 'budget_state.dart';

final budgetProvider =
StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});

 class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier() : super(
    BudgetState(
      limits: {
        RideType.mini: 5000,
        RideType.sedan: 8000,
        RideType.auto: 3000,
        RideType.bike: 2000,
      },
      spent: {},
    ),
  );

   void updateFromTrips(List<Trip> trips) {
    final now = DateTime.now();
    Map<RideType, double> newSpent = {};

    for (var t in trips) {
      if (t.dateTime.month == now.month && t.dateTime.year == now.year) {
        newSpent[t.rideType] = (newSpent[t.rideType] ?? 0) + t.fare;
      }
    }

    state = BudgetState(limits: state.limits, spent: newSpent);
  }


  double get totalSpent => state.spent.values.fold(0.0, (a, b) => a + b);
  double get totalLimit => state.limits.values.fold(0.0, (a, b) => a + b);
  bool get isLimitExceeded => totalSpent > totalLimit;


  double calculateMonthlySpend(List trips) {
    final now = DateTime.now();

    return trips
        .where((t) =>
    t.dateTime.month == now.month &&
        t.dateTime.year == now.year)
        .fold(0.0, (sum, t) => sum + t.fare);
  }

  void addExpense(RideType type, double amount) {
    final current = state.spent[type] ?? 0;
    state = BudgetState(
      limits: state.limits,
      spent: {...state.spent, type: current + amount},
    );
  }
}
