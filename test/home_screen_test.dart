import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/screens/home_screen.dart';
import 'package:habit_breaker_app/localization/app_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  setUp(() {
    // 设置测试的locale
    WidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Home screen has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          home: const HomeScreen(),
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
          locale: Locale('zh'), // 使用中文locale
        ),
      ),
    );

    // 使用正确的本地化字符串
    expect(find.text('戒断不良习惯'), findsOneWidget);
  });

  testWidgets('Home screen has navigation buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          home: const HomeScreen(),
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
          locale: Locale('zh'), // 使用中文locale
        ),
      ),
    );

    // 使用正确的本地化字符串
    expect(find.text('查看我的戒断'), findsOneWidget);
    expect(find.text('查看统计'), findsOneWidget);
  });
}