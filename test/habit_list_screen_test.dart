import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/features/habits/screens/habit_list_screen.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';

// Mock habit data
final mockHabits = [
  Habit(
    id: '1',
    name: 'Morning Exercise',
    description: 'Do 30 minutes of exercise',
    createdDate: DateTime.now().subtract(const Duration(days: 5)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 3,
  ),
  Habit(
    id: '2',
    name: 'Read Books',
    description: 'Read for 30 minutes',
    createdDate: DateTime.now().subtract(const Duration(days: 10)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 7,
  ),
];

void main() {
  testWidgets('Habit list screen displays habits', (WidgetTester tester) async {
    // Mock the habits provider
    final container = ProviderContainer(
      overrides: [
        habitsProvider.overrideWith((ref) => Future.value(mockHabits)),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: const HabitListScreen(),
        ),
      ),
    );

    // Wait for the future to resolve
    await tester.pumpAndSettle();

    // Verify that habit names are displayed
    expect(find.text('Morning Exercise'), findsOneWidget);
    expect(find.text('Read Books'), findsOneWidget);
  });

  testWidgets('Habit list screen shows empty state', (WidgetTester tester) async {
    // Mock the habits provider with empty list
    final container = ProviderContainer(
      overrides: [
        habitsProvider.overrideWith((ref) => Future.value([])),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: const HabitListScreen(),
        ),
      ),
    );

    // Wait for the future to resolve
    await tester.pumpAndSettle();

    // Verify that empty state message is displayed
    expect(find.text('No habits yet. Add your first habit!'), findsOneWidget);
  });
}