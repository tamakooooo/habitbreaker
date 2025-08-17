import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:habit_breaker_app/config/constants.dart';
import 'package:habit_breaker_app/models/habit.dart';

class StorageService {
  static final Logger _logger = Logger();
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Box? _habitsBox;
  Box? _settingsBox;

  // Initialize Hive boxes
  Future<void> init() async {
    // Initialize boxes for different data types
    _habitsBox = await Hive.openBox(AppConstants.habitsBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // Get all habits
  Future<List<Habit>> getHabits() async {
    if (_habitsBox == null) throw Exception('StorageService not initialized');
    
    final habits = <Habit>[];
    for (var key in _habitsBox!.keys) {
      final habitData = _habitsBox!.get(key);
      if (habitData is Map) {
        try {
          final habit = Habit.fromJson({...habitData, 'id': key.toString()});
          habits.add(habit);
        } catch (e) {
          // Handle any deserialization errors
          _logger.e('Error deserializing habit: $e');
        }
      }
    }
    return habits;
  }

  // Get a specific habit by ID
  Future<Habit?> getHabitById(String id) async {
    if (_habitsBox == null) throw Exception('StorageService not initialized');
    
    final habitData = _habitsBox!.get(id);
    if (habitData is Map) {
      try {
        return Habit.fromJson({...habitData, 'id': id});
      } catch (e) {
        // Handle any deserialization errors
        _logger.e('Error deserializing habit: $e');
        return null;
      }
    }
    return null;
  }

  // Save a habit
  Future<void> saveHabit(Habit habit) async {
    if (_habitsBox == null) throw Exception('StorageService not initialized');
    
    final habitData = habit.toJson()..remove('id');
    await _habitsBox!.put(habit.id, habitData);
  }

  // Delete a habit
  Future<void> deleteHabit(String id) async {
    if (_habitsBox == null) throw Exception('StorageService not initialized');
    await _habitsBox!.delete(id);
  }

  // Get settings
  Future<Map<String, dynamic>?> getSettings() async {
    if (_settingsBox == null) throw Exception('StorageService not initialized');
    return _settingsBox!.get('settings') as Map<String, dynamic>?;
  }

  // Save settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    if (_settingsBox == null) throw Exception('StorageService not initialized');
    await _settingsBox!.put('settings', settings);
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }
}