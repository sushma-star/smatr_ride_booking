
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ride_type.dart';
import '../provider/budget_provider.dart';
import '../provider/trip_provider.dart';

class MonthlyBudgetCard extends ConsumerWidget {
  const MonthlyBudgetCard({super.key});

  IconData _rideTypeIcon(RideType type) {
    switch (type) {
      case RideType.mini:
        return Icons.directions_car;
      case RideType.sedan:
        return Icons.airport_shuttle;
      case RideType.auto:
        return Icons.local_taxi;
      case RideType.bike:
        return Icons.two_wheeler;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripProvider);
    final budget = ref.watch(budgetProvider);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Ride Budget',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 20,
            children: RideType.values.map((type) {
              final spent = budget.spent[type] ?? 0;
              final limit = budget.limits[type] ?? 0;
              final isOver = spent >= limit;

              Color containerColor;
              Color iconColor;

              if (isOver) {
                containerColor = Colors.red.shade100;
                iconColor = Colors.red;
              } else if (spent > 0) {
                containerColor = theme.primaryColor.withOpacity(0.1);
                iconColor = theme.primaryColor;
              } else {
                containerColor = theme.dividerColor.withOpacity(0.2);
                iconColor = theme.primaryColor;
              }

              return Container(
                width: (MediaQuery.of(context).size.width - 64) / 2,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _rideTypeIcon(type),
                      color: iconColor,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      type.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${spent.toInt()} / ₹${limit.toInt()}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOver ? Colors.red : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(height: 20, thickness: 1),

          Text(
            (budget.totalLimit - budget.totalSpent).toInt() <= 0
                ? '⚠ Budget Exceeded!'
                : 'Remaining: ₹${(budget.totalLimit - budget.totalSpent).toInt()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: (budget.totalLimit - budget.totalSpent).toInt() <= 0
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
