// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyLevelAdapter extends TypeAdapter<EnergyLevel> {
  @override
  final int typeId = 7;

  @override
  EnergyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnergyLevel.low;
      case 1:
        return EnergyLevel.medium;
      case 2:
        return EnergyLevel.high;
      default:
        return EnergyLevel.low;
    }
  }

  @override
  void write(BinaryWriter writer, EnergyLevel obj) {
    switch (obj) {
      case EnergyLevel.low:
        writer.writeByte(0);
        break;
      case EnergyLevel.medium:
        writer.writeByte(1);
        break;
      case EnergyLevel.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyAdapter extends TypeAdapter<Difficulty> {
  @override
  final int typeId = 8;

  @override
  Difficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Difficulty.low;
      case 1:
        return Difficulty.medium;
      case 2:
        return Difficulty.high;
      default:
        return Difficulty.low;
    }
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    switch (obj) {
      case Difficulty.low:
        writer.writeByte(0);
        break;
      case Difficulty.medium:
        writer.writeByte(1);
        break;
      case Difficulty.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SSOProviderAdapter extends TypeAdapter<SSOProvider> {
  @override
  final int typeId = 9;

  @override
  SSOProvider read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SSOProvider.google;
      case 1:
        return SSOProvider.microsoft;
      default:
        return SSOProvider.google;
    }
  }

  @override
  void write(BinaryWriter writer, SSOProvider obj) {
    switch (obj) {
      case SSOProvider.google:
        writer.writeByte(0);
        break;
      case SSOProvider.microsoft:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SSOProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationContextAdapter extends TypeAdapter<LocationContext> {
  @override
  final int typeId = 10;

  @override
  LocationContext read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocationContext.home;
      case 1:
        return LocationContext.office;
      case 2:
        return LocationContext.gym;
      case 3:
        return LocationContext.outdoor;
      default:
        return LocationContext.home;
    }
  }

  @override
  void write(BinaryWriter writer, LocationContext obj) {
    switch (obj) {
      case LocationContext.home:
        writer.writeByte(0);
        break;
      case LocationContext.office:
        writer.writeByte(1);
        break;
      case LocationContext.gym:
        writer.writeByte(2);
        break;
      case LocationContext.outdoor:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationContextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WellnessGoalAdapter extends TypeAdapter<WellnessGoal> {
  @override
  final int typeId = 11;

  @override
  WellnessGoal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WellnessGoal.stressReduction;
      case 1:
        return WellnessGoal.increasedEnergy;
      case 2:
        return WellnessGoal.betterSleep;
      case 3:
        return WellnessGoal.physicalFitness;
      case 4:
        return WellnessGoal.healthyEating;
      case 5:
        return WellnessGoal.socialConnection;
      default:
        return WellnessGoal.stressReduction;
    }
  }

  @override
  void write(BinaryWriter writer, WellnessGoal obj) {
    switch (obj) {
      case WellnessGoal.stressReduction:
        writer.writeByte(0);
        break;
      case WellnessGoal.increasedEnergy:
        writer.writeByte(1);
        break;
      case WellnessGoal.betterSleep:
        writer.writeByte(2);
        break;
      case WellnessGoal.physicalFitness:
        writer.writeByte(3);
        break;
      case WellnessGoal.healthyEating:
        writer.writeByte(4);
        break;
      case WellnessGoal.socialConnection:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
