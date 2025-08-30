import 'package:flutter/material.dart';
import 'editable_progress_indicator.dart';

class HabitProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;
  final bool isEditable;
  final Function(double)? onProgressChanged;
  final String? label;
  final bool showPercentage;

  const HabitProgressIndicator({
    super.key,
    required this.progress,
    this.size = 100,
    this.color,
    this.isEditable = false,
    this.onProgressChanged,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    // 如果启用编辑功能，使用EditableProgressIndicator
    if (isEditable) {
      return EditableProgressIndicator(
        progress: progress,
        size: size,
        color: color,
        isEditable: isEditable,
        onProgressChanged: onProgressChanged,
        label: label,
        showPercentage: showPercentage,
      );
    }
    
    // 否则使用原有的静态显示
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
            backgroundColor: Theme.of(
              context,
            ).dividerColor.withAlpha((0.2 * 255).round()),
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
              if (showPercentage)
                Text(
                  '${(progress * 100).toStringAsFixed(2)}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (label != null)
                Text(
                  label!,
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
