// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 4;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      userId: fields[0] as String,
      currentStreak: fields[1] as int,
      longestStreak: fields[2] as int,
      totalActivitiesCompleted: fields[3] as int,
      weeklyGoalProgress: fields[4] as double,
      completedDays: (fields[5] as List).cast<DateTime>(),
      earnedBadges: (fields[6] as List).cast<Badge>(),
      recentHistory: (fields[7] as List).cast<CompletedActivity>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.currentStreak)
      ..writeByte(2)
      ..write(obj.longestStreak)
      ..writeByte(3)
      ..write(obj.totalActivitiesCompleted)
      ..writeByte(4)
      ..write(obj.weeklyGoalProgress)
      ..writeByte(5)
      ..write(obj.completedDays)
      ..writeByte(6)
      ..write(obj.earnedBadges)
      ..writeByte(7)
      ..write(obj.recentHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
