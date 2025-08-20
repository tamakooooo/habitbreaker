import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';

class HabitCard extends StatefulWidget {
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
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late DateTime _currentTime;
  late Duration _remainingTime;
  late double _progress;
  late int _daysRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    _currentTime = DateTime.now();
    _remainingTime = widget.habit.targetEndDate.difference(_currentTime);
    _daysRemaining = _remainingTime.inDays;
    
    final totalDuration = widget.habit.targetEndDate.difference(widget.habit.startDate);
    final elapsedDuration = _currentTime.difference(widget.habit.startDate);
    
    if (elapsedDuration.isNegative) {
      _progress = 0.0;
    } else if (elapsedDuration >= totalDuration) {
      _progress = 1.0;
    } else {
      _progress = elapsedDuration.inSeconds / totalDuration.inSeconds;
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    return '${twoDigits(days)}:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  String _getCurrentStageLabel() {
    final elapsedDuration = _currentTime.difference(widget.habit.startDate);
    final elapsedDays = elapsedDuration.inDays;

    // Determine current stage based on abstinence duration
    if (elapsedDays < 1) {
      return AppLocalizations.of(context).stage24Hours;
    } else if (elapsedDays < 3) {
      return AppLocalizations.of(context).stage24Hours;
    } else if (elapsedDays < 7) {
      return AppLocalizations.of(context).stage3Days;
    } else if (elapsedDays < 30) {
      return AppLocalizations.of(context).stage1Week;
    } else if (elapsedDays < 90) {
      return AppLocalizations.of(context).stage1Month;
    } else if (elapsedDays < 180) {
      return AppLocalizations.of(context).stage1Quarter;
    } else if (elapsedDays < 365) {
      return AppLocalizations.of(context).stage1Year;
    } else {
      return AppLocalizations.of(context).stage1Year;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.habit.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                Text(
                  '${AppLocalizations.of(context).timeRemaining}: ${_formatTime(_remainingTime)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.habit.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).toStringAsFixed(1)}% ${AppLocalizations.of(context).completed}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context).stage}: ${_getCurrentStageLabel()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}