import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:habit_breaker_app/widgets/elapsed_time_counter.dart';
import 'package:logger/logger.dart';

class HabitDetailScreen extends ConsumerWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitProvider(habitId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).habitDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 添加日志记录
            final logger = Logger();
            logger.d('返回按钮被点击');

            try {
              // 检查是否可以返回
              if (GoRouter.of(context).canPop()) {
                logger.d('使用context.pop()返回');
                context.pop();
              } else {
                logger.d('无法pop，导航到主页');
                // 如果无法pop，则返回到主页
                context.go('/');
              }
            } catch (e, stackTrace) {
              logger.e('返回操作出错: $e', error: e, stackTrace: stackTrace);
              // 备选方案：直接导航到主页
              context.go('/');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit habit screen
              context.push('/habits/$habitId/edit');
            },
          ),
        ],
      ),
      body: habitAsync.when(
        data: (habit) => HabitDetailBody(habit: habit),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class HabitDetailBody extends ConsumerWidget {
  final Habit habit;

  const HabitDetailBody({super.key, required this.habit});

  void _completeHabit(BuildContext context, WidgetRef ref) {
    // In a real implementation, you would call the habit service here
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit marked as completed for today!')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(habit.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(habit.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text(
            '${AppLocalizations.of(context).startDate}: ${habit.startDate.toString()}',
          ),
          const SizedBox(height: 16),
          ElapsedTimeCounter(habit: habit),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _completeHabit(context, ref),
            child: Text(AppLocalizations.of(context).markCompletedToday),
          ),
        ],
      ),
    );
  }
}
