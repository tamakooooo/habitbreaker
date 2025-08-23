import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';

class ElapsedTimeCounter extends StatefulWidget {
  final Habit habit;

  const ElapsedTimeCounter({super.key, required this.habit});

  @override
  State<ElapsedTimeCounter> createState() => _ElapsedTimeCounterState();
}

class _ElapsedTimeCounterState extends State<ElapsedTimeCounter> {
  late Timer _timer;
  late Duration _elapsedTime;

  @override
  void initState() {
    super.initState();
    _calculateElapsedTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateElapsedTime() {
    final now = DateTime.now();
    _elapsedTime = now.difference(widget.habit.startDate);
  }

  void _updateTimer() {
    setState(() {
      _calculateElapsedTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _elapsedTime.inDays;
    final hours = _elapsedTime.inHours.remainder(24);
    final minutes = _elapsedTime.inMinutes.remainder(60);
    final seconds = _elapsedTime.inSeconds.remainder(60);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).timeElapsed,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeUnit(context, days, 'Days'),
                _buildTimeUnit(context, hours, 'Hours'),
                _buildTimeUnit(context, minutes, 'Minutes'),
                _buildTimeUnit(context, seconds, 'Seconds'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, int value, String label) {
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