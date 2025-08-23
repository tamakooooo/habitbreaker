import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:habit_breaker_app/widgets/habit_card.dart';
import 'package:habit_breaker_app/widgets/streak_counter.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).myHabits),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 使用go方法返回主页，避免pop可能导致的黑屏问题
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/habits/add');
            },
            tooltip: AppLocalizations.of(context).addHabit,
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context).noHabitsYet),
            );
          }
          
          // Calculate overall streak data
          int totalStreak = 0;
          int longestStreak = 0;
          for (var habit in habits) {
            totalStreak += habit.streakCount;
            if (habit.streakCount > longestStreak) {
              longestStreak = habit.streakCount;
            }
          }
          
          return ListView.builder(
            itemCount: habits.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return StreakCounter(
                  streakCount: totalStreak,
                  longestStreak: longestStreak,
                );
              }
              final habit = habits[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: HabitCard(
                  habit: habit,
                  isCompact: false, // 在列表中使用标准版本
                  onTap: () {
                    context.go('/habits/${habit.id}');
                  },
                  onCheck: () {
                    // Handle habit completion
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}