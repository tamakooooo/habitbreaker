import 'package:flutter/material.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final Habit habit;
  
  const CountdownTimer({super.key, required this.habit});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late DateTime _targetDate;
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _targetDate = widget.habit.targetEndDate;
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateRemainingTime();
      });
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    if (_targetDate.isAfter(now)) {
      _remainingTime = _targetDate.difference(now);
    } else {
      _remainingTime = Duration.zero;
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
              AppLocalizations.of(context).timeRemaining,
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
              backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context).daysRemaining}: $days',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress() {
    final totalDuration = widget.habit.targetEndDate.difference(widget.habit.startDate);
    final elapsedDuration = DateTime.now().difference(widget.habit.startDate);
    
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