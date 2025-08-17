import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

enum HabitStage {
  @HiveField(0)
  hours24,
  @HiveField(1)
  days3,
  @HiveField(2)
  week1,
  @HiveField(3)
  month1,
  @HiveField(4)
  quarter1,
  @HiveField(5)
  year1
}

@HiveType(typeId: 0)
@JsonSerializable()
class Habit extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final DateTime createdDate;
  
  @HiveField(4)
  final DateTime targetEndDate;
  
  @HiveField(5)
  final bool isCompleted;
  
  @HiveField(6)
  final int streakCount;
  
  @HiveField(7)
  final List<DateTime> completionDates;
  
  @HiveField(8)
  final DateTime startDate;
  
  @HiveField(9)
  final HabitStage stage;
  
  @HiveField(10)
  final DateTime currentStageStartDate;
  
  @HiveField(11)
  final DateTime currentStageEndDate;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.targetEndDate,
    required this.startDate,
    this.isCompleted = false,
    this.streakCount = 0,
    List<DateTime>? completionDates,
    this.stage = HabitStage.hours24,
    DateTime? currentStageStartDate,
    DateTime? currentStageEndDate,
  }) : completionDates = completionDates ?? [],
       currentStageStartDate = currentStageStartDate ?? startDate,
       currentStageEndDate = currentStageEndDate ?? _calculateStageEndDate(startDate, HabitStage.hours24);

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdDate,
    DateTime? targetEndDate,
    DateTime? startDate,
    bool? isCompleted,
    int? streakCount,
    List<DateTime>? completionDates,
    HabitStage? stage,
    DateTime? currentStageStartDate,
    DateTime? currentStageEndDate,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      targetEndDate: targetEndDate ?? this.targetEndDate,
      startDate: startDate ?? this.startDate,
      isCompleted: isCompleted ?? this.isCompleted,
      streakCount: streakCount ?? this.streakCount,
      completionDates: completionDates ?? this.completionDates,
      stage: stage ?? this.stage,
      currentStageStartDate: currentStageStartDate ?? this.currentStageStartDate,
      currentStageEndDate: currentStageEndDate ?? this.currentStageEndDate,
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);
  
  static DateTime _calculateStageEndDate(DateTime startDate, HabitStage stage) {
    switch (stage) {
      case HabitStage.hours24:
        return startDate.add(const Duration(hours: 24));
      case HabitStage.days3:
        return startDate.add(const Duration(days: 3));
      case HabitStage.week1:
        return startDate.add(const Duration(days: 7));
      case HabitStage.month1:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case HabitStage.quarter1:
        return DateTime(startDate.year, startDate.month + 3, startDate.day);
      case HabitStage.year1:
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        createdDate,
        targetEndDate,
        startDate,
        isCompleted,
        streakCount,
        completionDates,
        stage,
        currentStageStartDate,
        currentStageEndDate,
      ];
}