import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/features/statistics/screens/statistics_screen.dart';
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
    isCompleted: true,
  ),
  Habit(
    id: '2',
    name: 'Read Books',
    description: 'Read for 30 minutes',
    createdDate: DateTime.now().subtract(const Duration(days: 10)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 7,
    isCompleted: false,
  ),
];

void main() {
  testWidgets('Statistics screen displays habit statistics', (WidgetTester tester) async {
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
          home: const StatisticsScreen(),
        ),
      ),
    );

    // Wait for the future to resolve
    await tester.pumpAndSettle();

    // Verify that statistics are displayed
    expect(find.text('2'), findsOneWidget); // Total habits
    expect(find.text('1'), findsOneWidget); // Completed habits
    expect(find.text('10'), findsOneWidget); // Total streaks (3 + 7)
    expect(find.text('5.0'), findsOneWidget); // Average streak (10 / 2)
  });

  testWidgets('Statistics screen shows empty state', (WidgetTester tester) async {
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
          home: const StatisticsScreen(),
        ),
      ),
    );

    // Wait for the future to resolve
    await tester.pumpAndSettle();

    // Verify that empty state message is displayed
    expect(find.text('No habits to show statistics for.'), findsOneWidget);
  });
}