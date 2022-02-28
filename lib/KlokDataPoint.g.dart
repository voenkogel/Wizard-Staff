// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KlokDataPoint.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KlokDataPointAdapter extends TypeAdapter<KlokDataPoint> {
  @override
  final int typeId = 1;

  @override
  KlokDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KlokDataPoint(
      id: fields[0] as int,
      dateTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, KlokDataPoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlokDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
