
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/trip_model.dart';

import '../../provider/trip_provider.dart';
import '../../widgets/ride_status_chip.dart';
import '../booking/live_booking_screen.dart';
import '../trips/add_trip_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/trip_model.dart';
import '../../provider/trip_provider.dart';
import '../../widgets/ride_status_chip.dart';
import '../booking/live_booking_screen.dart';
import '../trips/add_trip_screen.dart';

class TripTile extends ConsumerWidget {
  final Trip trip;
  final int index;

    TripTile({
    super.key,
    required this.trip,
    required this.index,
  });

  static const Color themeColor = Colors.blue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Map<RideStatus, Color> statusColors = {
      RideStatus.requested: Colors.grey,
      RideStatus.driverAssigned: Colors.orange,
      RideStatus.started: Colors.blue,
      RideStatus.completed: Colors.green,
    };

    final isActive = trip.status != RideStatus.completed;
    final shadowColor = isActive
        ? statusColors[trip.status]!.withOpacity(0.3)
        : isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);

    final cardColor = isDark ? Colors.grey[800]! : Colors.white;
    final locationBoxColor = isDark ? Colors.grey[700]! : Colors.grey.shade200;
    final textColor = isDark ? Colors.white70 : Colors.black54;

    return Dismissible(
      key: ValueKey(trip.id),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(),
      onDismissed: (_) {
        ref.read(tripProvider.notifier).deleteTrip(trip.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Trip deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                ref.read(tripProvider.notifier).addTrip(trip);
              },
            ),
          ),
        );
      },
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 300 + index * 70),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOut,
        builder: (_, val, child) => Transform.scale(scale: val, child: child),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 1),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isActive ? 24 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _locationBox(trip.pickup, Icons.my_location, locationBoxColor, textColor),
                    _arrowIcon(isDark),
                    _locationBox(trip.drop, Icons.location_on, locationBoxColor, textColor),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _fareChip(trip.fare, textColor),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (statusColors[trip.status] ?? Colors.grey)
                            .withOpacity(trip.status == RideStatus.completed ? 0.2 : 0.8),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: RideStatusChip(status: trip.status),
                    )
                    ,
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, height: 1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: isDark ? Colors.white54 : Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(trip.dateTime),
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (trip.status != RideStatus.completed)
                      _actionButton(
                        icon: Icons.navigation,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LiveBookingScreen(),
                            ),
                          );
                        },
                      ),
                    if (trip.status != RideStatus.completed)
                      _actionButton(
                        icon: Icons.edit,
                        color: themeColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddTripScreen(editTrip: trip),
                            ),
                          );
                        },
                      ),
                    const SizedBox(width: 16),
                    _actionButton(
                      icon: Icons.delete_outline,
                      color: Colors.redAccent,
                      onTap: () {
                        ref.read(tripProvider.notifier).deleteTrip(trip.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final Map<RideStatus, Color> statusColors = {
    RideStatus.requested: Colors.grey,
    RideStatus.driverAssigned: Colors.orange,
    RideStatus.started: Colors.blue,
    RideStatus.completed: Colors.green,
  };

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _locationBox(String text, IconData icon, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowIcon(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.grey[700] : Colors.white,
      ),
      child: Icon(
        Icons.arrow_forward,
        size: 18,
        color: isDark ? Colors.white54 : Colors.grey,
      ),
    );
  }
  Widget _fareChip(double fare, Color textColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: fare),
      duration: const Duration(milliseconds: 800),
      builder: (_, value, __) => Text(
        '₹${value.toInt()}',
        style:   TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: textColor,
        ),
      ),
    );
  }


  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Icon(icon, size: 18, color: color),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}










