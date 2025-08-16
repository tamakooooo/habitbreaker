import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/screens/home_screen.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';

void main() {
  testWidgets('Home screen has correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const HomeScreen(),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
        ),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Habit Breaker'), findsOneWidget);
  });

  testWidgets('Home screen has navigation buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const HomeScreen(),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
        ),
      ),
    );

    // Verify that navigation buttons are present
    expect(find.text('View My Habits'), findsOneWidget);
    expect(find.text('View Statistics'), findsOneWidget);
  });
}