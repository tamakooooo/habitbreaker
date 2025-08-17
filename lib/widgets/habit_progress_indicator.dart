import 'package:flutter/material.dart';

class HabitProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;

  const HabitProgressIndicator({
    super.key,
    required this.progress,
    this.size = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 8,
            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
            color: Colors.transparent,
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            color: color ?? Theme.of(context).primaryColor,
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}