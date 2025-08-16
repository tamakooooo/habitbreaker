import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

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
  }) : completionDates = completionDates ?? [];

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
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);

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
      ];
}