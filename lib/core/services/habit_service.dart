import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/services/storage_service.dart';

class HabitService {
  final StorageService _storageService = StorageService();

  // Get all habits
  Future<List<Habit>> getHabits() async {
    return await _storageService.getHabits();
  }

  // Get a specific habit by ID
  Future<Habit> getHabitById(String id) async {
    final habit = await _storageService.getHabitById(id);
    if (habit != null) {
      return habit;
    } else {
      throw Exception('Habit not found');
    }
  }

  // Create a new habit
  Future<Habit> createHabit(Habit habit) async {
    await _storageService.saveHabit(habit);
    return habit;
  }

  // Update an existing habit
  Future<Habit> updateHabit(Habit habit) async {
    await _storageService.saveHabit(habit);
    return habit;
  }

  // Delete a habit
  Future<void> deleteHabit(String id) async {
    await _storageService.deleteHabit(id);
  }

  // Mark habit as completed for today
  Future<Habit> completeHabitForToday(String id) async {
    final habit = await getHabitById(id);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if already completed today
    final isAlreadyCompletedToday = habit.completionDates.any((date) {
      final completionDate = DateTime(date.year, date.month, date.day);
      return completionDate.isAtSameMomentAs(today);
    });
    
    if (isAlreadyCompletedToday) {
      return habit;
    }
    
    final updatedHabit = habit.copyWith(
      completionDates: [...habit.completionDates, today],
      streakCount: habit.streakCount + 1,
    );
    
    await updateHabit(updatedHabit);
    return updatedHabit;
  }
}