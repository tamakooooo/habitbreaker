// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

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
      targetEndDate: fields[4] as DateTime,
      startDate: fields[8] as DateTime,
      isCompleted: fields[5] as bool,
      streakCount: fields[6] as int,
      completionDates: (fields[7] as List?)?.cast<DateTime>(),
      stage: fields[9] as HabitStage,
      currentStageStartDate: fields[10] as DateTime?,
      currentStageEndDate: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.targetEndDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.streakCount)
      ..writeByte(7)
      ..write(obj.completionDates)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.stage)
      ..writeByte(10)
      ..write(obj.currentStageStartDate)
      ..writeByte(11)
      ..write(obj.currentStageEndDate);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      targetEndDate: DateTime.parse(json['targetEndDate'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      completionDates: (json['completionDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      stage: $enumDecodeNullable(_$HabitStageEnumMap, json['stage']) ??
          HabitStage.hours24,
      currentStageStartDate: json['currentStageStartDate'] == null
          ? null
          : DateTime.parse(json['currentStageStartDate'] as String),
      currentStageEndDate: json['currentStageEndDate'] == null
          ? null
          : DateTime.parse(json['currentStageEndDate'] as String),
    );

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdDate': instance.createdDate.toIso8601String(),
      'targetEndDate': instance.targetEndDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'streakCount': instance.streakCount,
      'completionDates':
          instance.completionDates.map((e) => e.toIso8601String()).toList(),
      'startDate': instance.startDate.toIso8601String(),
      'stage': _$HabitStageEnumMap[instance.stage]!,
      'currentStageStartDate': instance.currentStageStartDate.toIso8601String(),
      'currentStageEndDate': instance.currentStageEndDate.toIso8601String(),
    };

const _$HabitStageEnumMap = {
  HabitStage.hours24: 'hours24',
  HabitStage.days3: 'days3',
  HabitStage.week1: 'week1',
  HabitStage.month1: 'month1',
  HabitStage.quarter1: 'quarter1',
  HabitStage.year1: 'year1',
};
