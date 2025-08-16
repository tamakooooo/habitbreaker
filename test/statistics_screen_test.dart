import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_breaker_app/features/statistics/screens/statistics_screen.dart';
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
    isCompleted: true,
    startDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Habit(
    id: '2',
    name: 'Read Books',
    description: 'Read for 30 minutes',
    createdDate: DateTime.now().subtract(const Duration(days: 10)),
    targetEndDate: DateTime.now().add(const Duration(days: 30)),
    streakCount: 7,
    isCompleted: false,
    startDate: DateTime.now().subtract(const Duration(days: 10)),
  ),
];

void main() {
  testWidgets('Statistics screen displays habit statistics', (WidgetTester tester) async {
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
          home: const StatisticsScreen(),
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

    // Verify that statistics are displayed
    expect(find.text('总习惯数'), findsWidgets); // Total habits title
    expect(find.text('已完成'), findsWidgets); // Completed title
    expect(find.text('总连续天数'), findsWidgets); // Total streaks title
    expect(find.text('平均连续天数'), findsWidgets); // Average streak title
  });

  testWidgets('Statistics screen shows empty state', (WidgetTester tester) async {
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
          home: const StatisticsScreen(),
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
    expect(find.text('No habits to show statistics for.'), findsOneWidget);
  });
}