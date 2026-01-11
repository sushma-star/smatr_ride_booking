import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

import '../models/trip_model.dart';
import '../models/ride_type.dart';

 Future<void> exportTrips(BuildContext context, List<Trip> trips) async {
  if (trips.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No trips to export')),
    );
    return;
  }

  try {
     List<List<String>> rows = [
      ['Pickup', 'Drop', 'Fare', 'Ride Type', 'Status', 'DateTime']
    ];

    for (var t in trips) {
      rows.add([
        t.pickup,
        t.drop,
        t.fare.toString(),
        t.rideType.label,
        t.status.name,
        t.dateTime.toIso8601String()
      ]);
    }

     String csvData = const ListToCsvConverter().convert(rows);

     final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/trips_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);

     await Share.shareXFiles([XFile(file.path)], text: 'My Trip History CSV');

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to export trips: $e')),
    );
  }
}
