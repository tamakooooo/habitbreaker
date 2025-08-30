import 'package:habit_breaker_app/models/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  // Initialize Hive with Flutter
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(HabitAdapter());
}
