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
  late Duration _elapsedTime;
  late double _progress;
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
    _elapsedTime = _currentTime.difference(widget.habit.startDate);
    
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

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    return '${twoDigits(days)}:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  String _getStageLabel() {
    final elapsedDays = _elapsedTime.inDays;
    
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
      return AppLocalizations.of(context).stage1Year.replaceAll('1 Year', '6 Months');
    } else {
      // 180天及以上
      return AppLocalizations.of(context).stage1Year;
    }
  }

  Widget _buildTimeUnit(int value, String label) {
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
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context).timeElapsed} - ${_getStageLabel()}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeUnit(
                    _elapsedTime.inDays,
                    'Days',
                  ),
                  _buildTimeUnit(
                    _elapsedTime.inHours % 24,
                    'Hours',
                  ),
                  _buildTimeUnit(
                    _elapsedTime.inMinutes % 60,
                    'Minutes',
                  ),
                  _buildTimeUnit(
                    _elapsedTime.inSeconds % 60,
                    'Seconds',
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
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).toStringAsFixed(1)}% ${AppLocalizations.of(context).completed}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}