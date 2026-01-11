import 'package:flutter/material.dart';
import '../models/trip_model.dart';
class RideStatusChip extends StatelessWidget {
  final RideStatus status;
  const RideStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
     final Map<RideStatus, Color> statusColors = {
      RideStatus.completed: Colors.green,
      RideStatus.started: Colors.blue,
      RideStatus.driverAssigned: Colors.orange,
    };

    final Map<RideStatus, IconData> statusIcons = {
      RideStatus.completed: Icons.check_circle,
      RideStatus.started: Icons.play_circle_fill,
      RideStatus.driverAssigned: Icons.person_pin_circle,
    };

    final color = statusColors[status] ?? Colors.grey;
    final icon = statusIcons[status] ?? Icons.help_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            status.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}


