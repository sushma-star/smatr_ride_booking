import '../models/ride_type.dart';

class BudgetState {
  final Map<RideType, double> limits;
  final Map<RideType, double> spent;

  const BudgetState({
    required this.limits,
    required this.spent,
  });

   double get totalSpent =>
      spent.values.fold(0.0, (a, b) => a + b);

   double get totalLimit =>
      limits.values.fold(0.0, (a, b) => a + b);

   bool get isLimitExceeded => totalSpent > totalLimit;

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
