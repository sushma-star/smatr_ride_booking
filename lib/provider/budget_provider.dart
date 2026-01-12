
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ride_type.dart';
import '../models/trip_model.dart';

 class BudgetState {
  final Map<RideType, double> limits;
  final Map<RideType, double> spent;
  final bool isLimitExceeded;
  const BudgetState({
    required this.limits,
    required this.spent,
    this.isLimitExceeded = false,

  });

   double get totalSpent => spent.values.fold(0.0, (a, b) => a + b);

   double get totalLimit => limits.values.fold(0.0, (a, b) => a + b);
  bool isLimitExceededFor(RideType type) {
    final spentAmount = spent[type] ?? 0;
    final limit = limits[type] ?? 0;
    return spentAmount >= limit;
  }


   double remainingFor(RideType type) {
    final limit = limits[type] ?? 0;
    final used = spent[type] ?? 0;
    return limit - used;
  }

   double usagePercent(RideType type) {
    final limit = limits[type] ?? 0;
    if (limit == 0) return 0;
    return (spent[type] ?? 0) / limit;
  }
}

 class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier()
      : super(
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

   void addExpense(RideType type, double amount) {
    final current = state.spent[type] ?? 0;
    state = BudgetState(
      limits: state.limits,
      spent: {...state.spent, type: current + amount},
    );
  }

   void updateFromTrips(List<Trip> trips) {
    final now = DateTime.now();
    Map<RideType, double> newSpent = {};

    for (var t in trips) {
      if (t.dateTime.month == now.month && t.dateTime.year == now.year) {
        newSpent[t.rideType] = (newSpent[t.rideType] ?? 0) + t.fare;
      }
    }

    state = BudgetState(
      limits: state.limits,
      spent: newSpent,
    );
  }
  bool isLimitExceededFor(RideType type) =>
      (state.spent[type] ?? 0) > (state.limits[type] ?? 0);

   double calculateMonthlySpend(List<Trip> trips) {
    final now = DateTime.now();
    return trips
        .where((t) => t.dateTime.month == now.month && t.dateTime.year == now.year)
        .fold(0.0, (sum, t) => sum + t.fare);
  }
}

 final budgetProvider =
StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});

