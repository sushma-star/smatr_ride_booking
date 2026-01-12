import '../models/ride_type.dart';

class BudgetState {
  final Map<RideType, double> limits;
  final Map<RideType, double> spent;
  final bool isLimitExceeded;


  const BudgetState({
    required this.limits,
    required this.spent,
    this.isLimitExceeded = false,

  });

   double get totalSpent =>
      spent.values.fold(0.0, (a, b) => a + b);

   double get totalLimit =>
      limits.values.fold(0.0, (a, b) => a + b);


   double remainingFor(RideType type) {
    final limit = limits[type] ?? 0;
    final used = spent[type] ?? 0;
    return limit - used;
  }
  bool isLimitExceededFor(RideType type) {
    final spentAmount = spent[type] ?? 0;
    final limit = limits[type] ?? 0;
    return spentAmount >= limit;
  }
   double usagePercent(RideType type) {
    final limit = limits[type] ?? 0;
    if (limit == 0) return 0;
    return (spent[type] ?? 0) / limit;
  }
}
