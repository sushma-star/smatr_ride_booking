import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/ride_type.dart';
import '../../models/trip_model.dart';


class TripChart extends StatelessWidget {
  final List<Trip> trips;
  const TripChart({super.key, required this.trips});

  static const Color primaryYellow = Color(0xFFF3C10B);

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) return _emptyState();

    final Map<RideType, int> data = {};
    for (var t in trips) {
      data[t.rideType] = (data[t.rideType] ?? 0) + 1;
    }

    final total = data.values.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Trips by Ride Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.pie_chart, color: primaryYellow),
            ],
          ),

          const SizedBox(height: 16),

           Row(
            children: [
               Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: SizedBox(
                    height: 140,
                    child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 38,
                          sections: data.entries.map((e) {
                            final percent =
                            ((e.value / total) * 100).toStringAsFixed(0);

                            return PieChartSectionData(
                              value: e.value.toDouble(),
                              title: '$percent%',
                              radius: 46,
                              titleStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 9,
                              ),
                              color: _rideColor(e.key),
                            );
                          }).toList(),
                        )

                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

               Expanded(
                flex: 2,
                child: Column(
                  children: data.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _legendItem(
                        label: e.key.label,
                        count: e.value,
                        color: _rideColor(e.key),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem({
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [


        const SizedBox(width: 6),

         Icon(
          iconFromLabel(label),
          size: 14,
          color: color,
        ),

        const SizedBox(width: 6),

         Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

         Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  IconData iconFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'bike':
        return Icons.two_wheeler;
      case 'auto':
        return Icons.local_taxi;
      case 'mini':
        return Icons.directions_car;
      case 'sedan':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car_filled;
    }
  }



   Color _rideColor(RideType type) {
    switch (type) {
      case RideType.mini:
        return primaryYellow;
      case RideType.sedan:
        return Colors.purple;
      case RideType.auto:
        return Colors.redAccent.withOpacity(0.75);
      case RideType.bike:
        return primaryYellow.withOpacity(0.5);
    }
  }

   Widget _emptyState() {
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        'No completed trips',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}




