// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 2;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      pickup: fields[1] as String,
      drop: fields[2] as String,
      rideType: fields[3] as RideType,
      fare: fields[4] as double,
      status: fields[5] as RideStatus,
      dateTime: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pickup)
      ..writeByte(2)
      ..write(obj.drop)
      ..writeByte(3)
      ..write(obj.rideType)
      ..writeByte(4)
      ..write(obj.fare)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RideStatusAdapter extends TypeAdapter<RideStatus> {
  @override
  final int typeId = 0;

  @override
  RideStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RideStatus.requested;
      case 1:
        return RideStatus.driverAssigned;
      case 2:
        return RideStatus.started;
      case 3:
        return RideStatus.completed;
      case 4:
        return RideStatus.cancelled;
      default:
        return RideStatus.requested;
    }
  }

  @override
  void write(BinaryWriter writer, RideStatus obj) {
    switch (obj) {
      case RideStatus.requested:
        writer.writeByte(0);
        break;
      case RideStatus.driverAssigned:
        writer.writeByte(1);
        break;
      case RideStatus.started:
        writer.writeByte(2);
        break;
      case RideStatus.completed:
        writer.writeByte(3);
        break;
      case RideStatus.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
