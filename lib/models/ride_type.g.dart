// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RideTypeAdapter extends TypeAdapter<RideType> {
  @override
  final int typeId = 1;

  @override
  RideType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RideType.mini;
      case 1:
        return RideType.sedan;
      case 2:
        return RideType.auto;
      case 3:
        return RideType.bike;
      default:
        return RideType.mini;
    }
  }

  @override
  void write(BinaryWriter writer, RideType obj) {
    switch (obj) {
      case RideType.mini:
        writer.writeByte(0);
        break;
      case RideType.sedan:
        writer.writeByte(1);
        break;
      case RideType.auto:
        writer.writeByte(2);
        break;
      case RideType.bike:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
