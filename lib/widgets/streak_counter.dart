import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  final int streakCount;
  final int longestStreak;
  final VoidCallback? onTap;

  const StreakCounter({
    super.key,
    required this.streakCount,
    required this.longestStreak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StreakItem(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    value: '$streakCount',
                    label: 'Current Streak',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).dividerColor,
                  ),
                  _StreakItem(
                    icon: Icons.emoji_events,
                    iconColor: Colors.amber,
                    value: '$longestStreak',
                    label: 'Longest Streak',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: streakCount > 0 ? 1.0 : 0.0,
                backgroundColor: Theme.of(
                  context,
                ).dividerColor.withAlpha((0.2 * 255).round()),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StreakItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}
