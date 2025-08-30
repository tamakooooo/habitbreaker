import 'package:go_router/go_router.dart';
import 'package:habit_breaker_app/screens/home_screen.dart';
import 'package:habit_breaker_app/features/auth/screens/login_screen.dart';
import 'package:habit_breaker_app/features/auth/screens/signup_screen.dart';
import 'package:habit_breaker_app/features/habits/screens/habit_list_screen.dart';
import 'package:habit_breaker_app/features/habits/screens/add_habit_screen.dart';
import 'package:habit_breaker_app/features/habits/screens/habit_detail_screen.dart';
import 'package:habit_breaker_app/features/habits/screens/edit_habit_screen.dart';
import 'package:habit_breaker_app/features/statistics/screens/statistics_screen.dart';
import 'package:habit_breaker_app/features/statistics/screens/test_chart_screen.dart';
import 'package:habit_breaker_app/features/settings/screens/settings_screen.dart';
import 'package:habit_breaker_app/screens/icon_demo_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/habits',
      builder: (context, state) => const HabitListScreen(),
    ),
    GoRoute(
      path: '/habits/add',
      builder: (context, state) => const AddHabitScreen(),
    ),
    GoRoute(
      path: '/habits/:id',
      builder: (context, state) {
        final habitId = state.pathParameters['id']!;
        return HabitDetailScreen(habitId: habitId);
      },
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) {
            final habitId = state.pathParameters['id']!;
            return EditHabitScreen(habitId: habitId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
    GoRoute(
      path: '/test-chart',
      builder: (context, state) => const TestChartScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/icon-demo',
      builder: (context, state) => const IconDemoScreen(),
    ),
  ],
);
