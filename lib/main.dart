import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:habit_breaker_app/core/router/app_router.dart';
import 'package:habit_breaker_app/core/services/storage_service.dart';
import 'package:habit_breaker_app/core/services/hive_init.dart';
import 'package:habit_breaker_app/core/services/notification_service.dart';
import 'package:habit_breaker_app/core/services/background_service.dart';
import 'package:habit_breaker_app/config/constants.dart';
import 'package:habit_breaker_app/config/themes.dart';
import 'package:habit_breaker_app/localization/app_localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data
  tz.initializeTimeZones();
  
  // Initialize Hive
  await initHive();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.init();
  
  // Initialize background task service
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  
  // Register periodic tasks
  await Workmanager().registerPeriodicTask(
    'checkHabitsTask',
    'checkHabits',
    frequency: const Duration(hours: 1),
    initialDelay: const Duration(minutes: 1),
  );
  
  await Workmanager().registerPeriodicTask(
    'dailyResetTask',
    'dailyReset',
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(hours: 1),
  );
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('zh', ''), // Chinese
      ],
    );
  }
}