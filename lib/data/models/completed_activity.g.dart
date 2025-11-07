// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletedActivityAdapter extends TypeAdapter<CompletedActivity> {
  @override
  final int typeId = 6;

  @override
  CompletedActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedActivity(
      activityId: fields[0] as String,
      activityName: fields[1] as String,
      completedAt: fields[2] as DateTime,
      pointsEarned: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedActivity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.activityId)
      ..writeByte(1)
      ..write(obj.activityName)
      ..writeByte(2)
      ..write(obj.completedAt)
      ..writeByte(3)
      ..write(obj.pointsEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
