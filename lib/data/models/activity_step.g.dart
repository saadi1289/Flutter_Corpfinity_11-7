// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_step.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityStepAdapter extends TypeAdapter<ActivityStep> {
  @override
  final int typeId = 3;

  @override
  ActivityStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityStep(
      stepNumber: fields[0] as int,
      title: fields[1] as String,
      instruction: fields[2] as String,
      imageUrl: fields[3] as String?,
      timerSeconds: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityStep obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.stepNumber)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.instruction)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.timerSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
