import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
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
  month3,
  @HiveField(5)
  year1,
}

@HiveType(typeId: 1)
enum RepeatFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  custom,
}

@HiveType(typeId: 2)
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
  final DateTime startDate;
  @HiveField(5)
  final DateTime targetEndDate;
  @HiveField(6)
  final bool isCompleted;
  @HiveField(7)
  final int streakCount;
  @HiveField(8)
  final List<DateTime> completionDates;
  @HiveField(9)
  final HabitStage stage;
  @HiveField(10)
  final DateTime currentStageStartDate;
  @HiveField(11)
  final DateTime currentStageEndDate;
  @HiveField(12)
  final String icon;
  @HiveField(13)
  final TimeOfDay? reminderTime;
  @HiveField(14)
  final bool isReminderEnabled;
  @HiveField(15)
  final RepeatFrequency repeatFrequency;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.startDate,
    required this.targetEndDate,
    this.isCompleted = false,
    this.streakCount = 0,
    this.completionDates = const [],
    required this.stage,
    required this.currentStageStartDate,
    required this.currentStageEndDate,
    required this.icon,
    this.reminderTime,
    this.isReminderEnabled = false,
    this.repeatFrequency = RepeatFrequency.daily,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdDate,
    DateTime? startDate,
    DateTime? targetEndDate,
    bool? isCompleted,
    int? streakCount,
    List<DateTime>? completionDates,
    HabitStage? stage,
    DateTime? currentStageStartDate,
    DateTime? currentStageEndDate,
    String? icon,
    TimeOfDay? reminderTime,
    bool? isReminderEnabled,
    RepeatFrequency? repeatFrequency,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      startDate: startDate ?? this.startDate,
      targetEndDate: targetEndDate ?? this.targetEndDate,
      isCompleted: isCompleted ?? this.isCompleted,
      streakCount: streakCount ?? this.streakCount,
      completionDates: completionDates ?? this.completionDates,
      stage: stage ?? this.stage,
      currentStageStartDate: currentStageStartDate ?? this.currentStageStartDate,
      currentStageEndDate: currentStageEndDate ?? this.currentStageEndDate,
      icon: icon ?? this.icon,
      reminderTime: reminderTime ?? this.reminderTime,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
    );
  }

  static DateTime calculateStageEndDate(DateTime startDate, HabitStage stage) {
    switch (stage) {
      case HabitStage.hours24:
        return startDate.add(const Duration(hours: 24));
      case HabitStage.days3:
        return startDate.add(const Duration(days: 3));
      case HabitStage.week1:
        return startDate.add(const Duration(days: 7));
      case HabitStage.month1:
        return startDate.add(const Duration(days: 30));
      case HabitStage.month3:
        return startDate.add(const Duration(days: 90));
      case HabitStage.year1:
        return startDate.add(const Duration(days: 365));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'targetEndDate': targetEndDate.toIso8601String(),
      'isCompleted': isCompleted,
      'streakCount': streakCount,
      'completionDates': completionDates.map((e) => e.toIso8601String()).toList(),
      'stage': stage.name,
      'currentStageStartDate': currentStageStartDate.toIso8601String(),
      'currentStageEndDate': currentStageEndDate.toIso8601String(),
      'icon': icon,
      'reminderTime': reminderTime != null 
          ? {'hour': reminderTime!.hour, 'minute': reminderTime!.minute}
          : null,
      'isReminderEnabled': isReminderEnabled,
      'repeatFrequency': repeatFrequency.name,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      startDate: DateTime.parse(json['startDate']),
      targetEndDate: DateTime.parse(json['targetEndDate']),
      isCompleted: json['isCompleted'] ?? false,
      streakCount: json['streakCount'] ?? 0,
      completionDates: (json['completionDates'] as List?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ?? [],
      stage: HabitStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => HabitStage.hours24,
      ),
      currentStageStartDate: DateTime.parse(json['currentStageStartDate']),
      currentStageEndDate: DateTime.parse(json['currentStageEndDate']),
      icon: json['icon'],
      reminderTime: json['reminderTime'] != null
          ? TimeOfDay(
              hour: json['reminderTime']['hour'],
              minute: json['reminderTime']['minute'],
            )
          : null,
      isReminderEnabled: json['isReminderEnabled'] ?? false,
      repeatFrequency: RepeatFrequency.values.firstWhere(
        (e) => e.name == json['repeatFrequency'],
        orElse: () => RepeatFrequency.daily,
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        createdDate,
        startDate,
        targetEndDate,
        isCompleted,
        streakCount,
        completionDates,
        stage,
        currentStageStartDate,
        currentStageEndDate,
        icon,
        reminderTime,
        isReminderEnabled,
        repeatFrequency,
      ];
}