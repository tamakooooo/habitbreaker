import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'dart:async';

class CountdownTimer extends ConsumerStatefulWidget {
  final Habit habit;
  
  const CountdownTimer({super.key, required this.habit});

  @override
  ConsumerState<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends ConsumerState<CountdownTimer> {
  late DateTime _targetDate;
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _targetDate = widget.habit.currentStageEndDate;
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateRemainingTime();
        _checkStageCompletion();
      });
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    // Calculate elapsed time since start date
    _remainingTime = now.difference(widget.habit.startDate);
  }
  
  void _checkStageCompletion() {
    final now = DateTime.now();
    if (now.isAfter(_targetDate)) {
      // Stage completed, move to next stage
      _advanceToNextStage();
    }
  }
  
  void _advanceToNextStage() async {
    // Update the habit with the next stage
    try {
      final habitService = ref.read(habitServiceProvider);
      final updatedHabit = await habitService.advanceHabitToNextStage(widget.habit.id);
      
      if (mounted) {
        setState(() {
          _targetDate = updatedHabit.currentStageEndDate;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stage completed! Moving to next stage.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error advancing stage: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${AppLocalizations.of(context).timeElapsed} - ${_getStageLabel()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimeUnit(
                  value: days,
                  label: AppLocalizations.of(context).days,
                ),
                _TimeUnit(
                  value: hours,
                  label: AppLocalizations.of(context).hours,
                ),
                _TimeUnit(
                  value: minutes,
                  label: AppLocalizations.of(context).minutes,
                ),
                _TimeUnit(
                  value: seconds,
                  label: AppLocalizations.of(context).seconds,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _calculateProgress(),
              backgroundColor: Theme.of(context).dividerColor.withAlpha((0.2 * 255).round()),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context).daysElapsed}: $days',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  String _getStageLabel() {
    final elapsedDays = _remainingTime.inDays;
    
    // 根据已用天数自动确定阶段
    if (elapsedDays < 1) {
      // 少于1天，显示小时
      return AppLocalizations.of(context).stage24Hours;
    } else if (elapsedDays < 3) {
      // 少于3天
      return AppLocalizations.of(context).stage3Days;
    } else if (elapsedDays < 7) {
      // 少于1周
      return AppLocalizations.of(context).stage1Week;
    } else if (elapsedDays < 30) {
      // 少于1个月
      return AppLocalizations.of(context).stage1Month;
    } else if (elapsedDays < 90) {
      // 少于1个季度
      return AppLocalizations.of(context).stage1Quarter;
    } else if (elapsedDays < 180) {
      // 少于半年
      return AppLocalizations.of(context).stage1Year; // 这里使用年作为半年的标签
    } else {
      // 180天及以上
      return AppLocalizations.of(context).stage1Year;
    }
  }

  double _calculateProgress() {
    final totalDuration = widget.habit.currentStageEndDate.difference(widget.habit.currentStageStartDate);
    final elapsedDuration = DateTime.now().difference(widget.habit.currentStageStartDate);
    
    if (totalDuration.inSeconds <= 0) return 1.0;
    
    final progress = elapsedDuration.inSeconds / totalDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;

  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Extension to provide localized time unit labels
extension on AppLocalizations {
  String get days => locale.languageCode == 'zh' ? '天' : 'Days';
  String get hours => locale.languageCode == 'zh' ? '小时' : 'Hours';
  String get minutes => locale.languageCode == 'zh' ? '分钟' : 'Minutes';
  String get seconds => locale.languageCode == 'zh' ? '秒' : 'Seconds';
}