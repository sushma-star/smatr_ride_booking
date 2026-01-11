
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/trip_model.dart';

import '../../provider/trip_provider.dart';
import '../../widgets/ride_status_chip.dart';
import '../trips/add_trip_screen.dart';




class TripTile extends ConsumerWidget {
  final Trip trip;
  final int index;

  const TripTile({
    super.key,
    required this.trip,
    required this.index,
  });

  static const Color themeColor = Colors.blue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<RideStatus, Color> statusColors = {
      RideStatus.requested: Colors.grey,
      RideStatus.driverAssigned: Colors.orange,
      RideStatus.started: Colors.blue,
      RideStatus.completed: Colors.green,
    };

    final isActive = trip.status != RideStatus.completed;
    final shadowColor = isActive
        ? statusColors[trip.status]!.withOpacity(0.3)
        : Colors.black.withOpacity(0.05);

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
        builder: (_, val, child) =>
            Transform.scale(scale: val, child: child),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 1),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    _locationBox(trip.pickup, Icons.my_location),
                    _arrowIcon(),
                    _locationBox(trip.drop, Icons.location_on),
                  ],
                ),
              ),

               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _fareChip(trip.fare),
                    RideStatusChip(status: trip.status),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, height: 1),

               Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(trip.dateTime),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                        ref
                            .read(tripProvider.notifier)
                            .deleteTrip(trip.id);
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

  Widget _locationBox(String text, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Icon(
        Icons.arrow_forward,
        size: 18,
        color: Colors.grey,
      ),
    );
  }

  Widget _fareChip(double fare) {
    return Text(
      '₹${fare.toStringAsFixed(0)}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 19,
        color: Colors.black87,
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







