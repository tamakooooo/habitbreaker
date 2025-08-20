import 'package:flutter_test/flutter_test.dart';
import 'package:habit_breaker_app/models/habit.dart';

void main() {
  group('Habit Model', () {
    test('Habit can be created with required fields', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Test Habit',
        description: 'Test Description',
        createdDate: now,
        startDate: now,
        targetEndDate: now.add(const Duration(days: 30)),
        stage: HabitStage.hours24,
        currentStageStartDate: now,
        currentStageEndDate: now.add(const Duration(hours: 24)),
        icon: 'MdiIcons.target',
      );

      expect(habit.id, '1');
      expect(habit.name, 'Test Habit');
      expect(habit.description, 'Test Description');
      expect(habit.streakCount, 0);
      expect(habit.completionDates, isEmpty);
    });

    test('Habit can be copied with new values', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Test Habit',
        description: 'Test Description',
        createdDate: now,
        startDate: now,
        targetEndDate: now.add(const Duration(days: 30)),
        stage: HabitStage.hours24,
        currentStageStartDate: now,
        currentStageEndDate: now.add(const Duration(hours: 24)),
        icon: 'MdiIcons.target',
      );

      final updatedHabit = habit.copyWith(
        name: 'Updated Habit',
        streakCount: 5,
        isCompleted: true,
      );

      expect(updatedHabit.id, '1');
      expect(updatedHabit.name, 'Updated Habit');
      expect(updatedHabit.description, 'Test Description');
      expect(updatedHabit.streakCount, 5);
      expect(updatedHabit.isCompleted, true);
    });

    test('Habit equality works correctly', () {
      final date = DateTime.now();
      final habit1 = Habit(
        id: '1',
        name: 'Test Habit',
        description: 'Test Description',
        createdDate: date,
        startDate: date,
        targetEndDate: date.add(const Duration(days: 30)),
        stage: HabitStage.hours24,
        currentStageStartDate: date,
        currentStageEndDate: date.add(const Duration(hours: 24)),
        icon: 'MdiIcons.target',
      );

      final habit2 = Habit(
        id: '1',
        name: 'Test Habit',
        description: 'Test Description',
        createdDate: date,
        startDate: date,
        targetEndDate: date.add(const Duration(days: 30)),
        stage: HabitStage.hours24,
        currentStageStartDate: date,
        currentStageEndDate: date.add(const Duration(hours: 24)),
        icon: 'MdiIcons.target',
      );

      expect(habit1, equals(habit2));
    });
  });
}