import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_breaker_app/features/habits/screens/habit_list_screen.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:habit_breaker_app/localization/app_localizations_delegate.dart';

// Mock habit data
final mockHabits = [
  Habit(
    id: '1',
    name: 'Morning Exercise',
    description: 'Do 30 minutes of exercise',
    createdDate: DateTime.now().subtract(const Duration(days: 5)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 3,
    startDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Habit(
    id: '2',
    name: 'Read Books',
    description: 'Read for 30 minutes',
    createdDate: DateTime.now().subtract(const Duration(days: 10)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 7,
    startDate: DateTime.now().subtract(const Duration(days: 10)),
  ),
];

void main() {
  testWidgets('Habit list screen displays habits', (WidgetTester tester) async {
    // Mock the habits provider
    final container = ProviderContainer(
      overrides: [
        habitsProvider.overrideWith((ref) async => mockHabits),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: const HabitListScreen(),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          locale: const Locale('zh'),
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
        habitsProvider.overrideWith((ref) async => []),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: const HabitListScreen(),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          locale: const Locale('zh'),
        ),
      ),
    );

    // Wait for the future to resolve
    await tester.pumpAndSettle();

    // Verify that empty state message is displayed
    expect(find.text('还没有习惯。添加你的第一个习惯！'), findsOneWidget);
  });
}