import 'package:hive/hive.dart';

part 'ride_type.g.dart';

@HiveType(typeId: 1)
enum RideType {
  @HiveField(0)
  mini,
  @HiveField(1)
  sedan,
  @HiveField(2)
  auto,
  @HiveField(3)
  bike,
}

extension RideTypeX on RideType {
  String get label => name.toUpperCase();
}
