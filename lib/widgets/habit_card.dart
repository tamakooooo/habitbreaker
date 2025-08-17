import 'package:flutter/material.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onCheck;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = habit.targetEndDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Habit info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          habit.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).hintColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Days remaining
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$daysRemaining',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              LinearProgressIndicator(
                value: _calculateProgress(),
                backgroundColor: Theme.of(context).dividerColor.withAlpha((0.2 * 255).round()),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).stage}: ${_getStageLabel(context)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Days: ${(habit.currentStageEndDate.difference(DateTime.now()).inDays).toString()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getStageLabel(BuildContext context) {
    switch (habit.stage) {
      case HabitStage.hours24:
        return '24 Hours';
      case HabitStage.days3:
        return '3 Days';
      case HabitStage.week1:
        return '1 Week';
      case HabitStage.month1:
        return '1 Month';
      case HabitStage.quarter1:
        return '1 Quarter';
      case HabitStage.year1:
        return '1 Year';
      default:
        return '';
    }
  }

  double _calculateProgress() {
    final totalDuration = habit.currentStageEndDate.difference(habit.currentStageStartDate);
    final elapsedDuration = DateTime.now().difference(habit.currentStageStartDate);
    
    if (totalDuration.inSeconds <= 0) return 1.0;
    
    final progress = elapsedDuration.inSeconds / totalDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }
}