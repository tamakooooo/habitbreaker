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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间选择
        ListTile(
          title: const Text('选择时间'),
          subtitle: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
          trailing: const Icon(Icons.access_time),
          onTap: _showTimePicker,
        ),
      ],
    );
  }
}