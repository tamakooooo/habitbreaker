// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 2;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      createdDate: fields[3] as DateTime,
      startDate: fields[4] as DateTime,
      targetEndDate: fields[5] as DateTime,
      isCompleted: fields[6] as bool,
      streakCount: fields[7] as int,
      completionDates: (fields[8] as List).cast<DateTime>(),
      stage: fields[9] as HabitStage,
      currentStageStartDate: fields[10] as DateTime,
      currentStageEndDate: fields[11] as DateTime,
      icon: fields[12] as String,
      reminderTime: fields[13] as TimeOfDay?,
      isReminderEnabled: fields[14] as bool,
      repeatFrequency: fields[15] as RepeatFrequency,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.targetEndDate)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.streakCount)
      ..writeByte(8)
      ..write(obj.completionDates)
      ..writeByte(9)
      ..write(obj.stage)
      ..writeByte(10)
      ..write(obj.currentStageStartDate)
      ..writeByte(11)
      ..write(obj.currentStageEndDate)
      ..writeByte(12)
      ..write(obj.icon)
      ..writeByte(13)
      ..write(obj.reminderTime)
      ..writeByte(14)
      ..write(obj.isReminderEnabled)
      ..writeByte(15)
      ..write(obj.repeatFrequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitStageAdapter extends TypeAdapter<HabitStage> {
  @override
  final int typeId = 0;

  @override
  HabitStage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitStage.hours24;
      case 1:
        return HabitStage.days3;
      case 2:
        return HabitStage.week1;
      case 3:
        return HabitStage.month1;
      case 4:
        return HabitStage.month3;
      case 5:
        return HabitStage.year1;
      default:
        return HabitStage.hours24;
    }
  }

  @override
  void write(BinaryWriter writer, HabitStage obj) {
    switch (obj) {
      case HabitStage.hours24:
        writer.writeByte(0);
        break;
      case HabitStage.days3:
        writer.writeByte(1);
        break;
      case HabitStage.week1:
        writer.writeByte(2);
        break;
      case HabitStage.month1:
        writer.writeByte(3);
        break;
      case HabitStage.month3:
        writer.writeByte(4);
        break;
      case HabitStage.year1:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatFrequencyAdapter extends TypeAdapter<RepeatFrequency> {
  @override
  final int typeId = 1;

  @override
  RepeatFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatFrequency.daily;
      case 1:
        return RepeatFrequency.weekly;
      case 2:
        return RepeatFrequency.monthly;
      case 3:
        return RepeatFrequency.custom;
      default:
        return RepeatFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatFrequency obj) {
    switch (obj) {
      case RepeatFrequency.daily:
        writer.writeByte(0);
        break;
      case RepeatFrequency.weekly:
        writer.writeByte(1);
        break;
      case RepeatFrequency.monthly:
        writer.writeByte(2);
        break;
      case RepeatFrequency.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
