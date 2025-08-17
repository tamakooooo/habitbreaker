import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:habit_breaker_app/widgets/countdown_timer.dart';

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
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit habit screen
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

  String _getStageLabel(HabitStage stage) {
    switch (stage) {
      case HabitStage.hours24:
        return AppLocalizations.of(context).stageHours24;
      case HabitStage.days3:
        return AppLocalizations.of(context).stageDays3;
      case HabitStage.week1:
        return AppLocalizations.of(context).stageWeek1;
      case HabitStage.month1:
        return AppLocalizations.of(context).stageMonth1;
      case HabitStage.quarter1:
        return AppLocalizations.of(context).stageQuarter1;
      case HabitStage.year1:
        return AppLocalizations.of(context).stageYear1;
      default:
        return '';
    }
  }

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
          Text(
            habit.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            habit.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text('${AppLocalizations.of(context).startDate}: ${habit.startDate.toString().split(' ').first}'),
          Text('${AppLocalizations.of(context).stage}: ${_getStageLabel(habit.stage)}'),
          const SizedBox(height: 16),
          CountdownTimer(habit: habit),
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