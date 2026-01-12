import 'package:hive/hive.dart';


@HiveType(typeId: 3)
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
