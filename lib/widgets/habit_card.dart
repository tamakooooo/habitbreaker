import 'dart:async';
import 'package:flutter/material.dart';
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
                AppLocalizations.of(context).timeElapsed,
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
              // 美观的自定义进度条
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // 进度条背景
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // 进度条前景
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progress > 1.0 ? 1.0 : _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _progress >= 1.0 
                              ? Colors.green // 完成时显示绿色
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _progress >= 1.0 
                                  ? Colors.green.withValues(alpha: 0.5)
                                  : Theme.of(context).primaryColor.withValues(alpha: 0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 进度文本
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_progress * 100).toStringAsFixed(1)}% ${AppLocalizations.of(context).completed}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${widget.habit.startDate.toString().split(' ')[0]} - ${widget.habit.targetEndDate.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
}