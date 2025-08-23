import 'package:flutter/material.dart';

class TimePickerWithPresets extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWithPresets({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<TimePickerWithPresets> createState() => _TimePickerWithPresetsState();
}

class _TimePickerWithPresetsState extends State<TimePickerWithPresets> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  // 预设时间选项（分钟）
  final List<int> _presetMinutes = [15, 30, 45, 60, 90, 120];

  Future<void> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  void _selectPresetTime(int minutes) {
    // 将分钟转换为小时和分钟
    final hours = (minutes / 60).floor();
    final mins = minutes % 60;
    
    final newTime = TimeOfDay(hour: hours, minute: mins);
    setState(() {
      _selectedTime = newTime;
    });
    widget.onTimeSelected(newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 预设时间选项按钮
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '常用时长',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _presetMinutes.map((minutes) {
            return ChoiceChip(
              label: Text(_formatMinutes(minutes)),
              selected: false,
              onSelected: (selected) {
                if (selected) {
                  _selectPresetTime(minutes);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // 自定义时间选择
        ListTile(
          title: const Text('自定义时间'),
          subtitle: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
          trailing: const Icon(Icons.access_time),
          onTap: _showTimePicker,
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes分钟';
    } else if (minutes == 60) {
      return '1小时';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours小时';
      } else {
        return '$hours小时$remainingMinutes分钟';
      }
    }
  }
}