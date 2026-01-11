import 'package:hive/hive.dart';
import 'ride_type.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 0)
enum RideStatus {
  @HiveField(0)
  requested,
  @HiveField(1)
  driverAssigned,
  @HiveField(2)
  started,
  @HiveField(3)
  completed,
  @HiveField(4)
  cancelled,
}

@HiveType(typeId: 2)
class Trip extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String pickup;

  @HiveField(2)
  String drop;

  @HiveField(3)
  RideType rideType;

  @HiveField(4)
  double fare;

  @HiveField(5)
  RideStatus status;

  @HiveField(6)
  DateTime dateTime;

  Trip({
    required this.id,
    required this.pickup,
    required this.drop,
    required this.rideType,
    required this.fare,
    required this.status,
    required this.dateTime,
  });

  Trip copyWith({
    String? id,
    String? pickup,
    String? drop,
    RideType? rideType,
    double? fare,
    RideStatus? status,
    DateTime? dateTime,
  }) {
    return Trip(
      id: id ?? this.id,
      pickup: pickup ?? this.pickup,
      drop: drop ?? this.drop,
      rideType: rideType ?? this.rideType,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
