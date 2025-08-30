import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/core/services/habit_service.dart';
import 'package:habit_breaker_app/models/habit.dart';

// Provider for HabitService
final habitServiceProvider = Provider<HabitService>((ref) {
  return HabitService();
});

// Provider for the list of habits
final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final habitService = ref.watch(habitServiceProvider);
  return habitService.getHabits();
});

// Provider for a specific habit by ID
final habitProvider = FutureProvider.family<Habit, String>((ref, id) async {
  final habitService = ref.watch(habitServiceProvider);
  return habitService.getHabitById(id);
});
