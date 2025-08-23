import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../models/habit.dart';
import '../../../core/providers/habit_providers.dart';
import '../../../localization/app_localizations.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _startDate;
  TimeOfDay _startTime = TimeOfDay.now();
  String? _selectedIcon = 'MdiIcons.target';
  TimeOfDay? _reminderTime;
  bool _isReminderEnabled = false;
  RepeatFrequency _repeatFrequency = RepeatFrequency.daily;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) return;

    // For simplicity, we'll set targetEndDate to 1 year from start date
    final targetEndDate = _startDate!.add(const Duration(days: 365));
    
    final newHabit = Habit(
      id: const Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      createdDate: DateTime.now(),
      startDate: _startDate!,
      targetEndDate: targetEndDate,
      stage: HabitStage.year1, // Default to year stage
      icon: _selectedIcon ?? 'MdiIcons.target',
      reminderTime: _reminderTime,
      isReminderEnabled: _isReminderEnabled,
      repeatFrequency: _repeatFrequency,
      currentStageStartDate: _startDate!,
      currentStageEndDate: targetEndDate,
    );

    try {
      final habitService = ref.read(habitServiceProvider);
      await habitService.createHabit(newHabit);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).habitCreated)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
        );
      }
    }
  }


  String _getRepeatFrequencyDisplayName(BuildContext context, RepeatFrequency frequency) {
    final loc = AppLocalizations.of(context);
    switch (frequency) {
      case RepeatFrequency.daily:
        return loc.daily;
      case RepeatFrequency.weekly:
        return loc.weekly;
      case RepeatFrequency.monthly:
        return loc.monthly;
      case RepeatFrequency.custom:
        return loc.custom;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<String?> _selectIcon(BuildContext context) async {
    final icons = [
      {'name': '目标', 'icon': MdiIcons.target},
      {'name': '星星', 'icon': MdiIcons.star},
      {'name': '心形', 'icon': MdiIcons.heart},
      {'name': '奖杯', 'icon': MdiIcons.trophy},
      {'name': '闪电', 'icon': MdiIcons.lightningBolt},
      {'name': '吸烟', 'icon': MdiIcons.smokingOff},
      {'name': '酒精', 'icon': MdiIcons.glassWine},
      {'name': '咖啡', 'icon': MdiIcons.coffee},
      {'name': '手机', 'icon': MdiIcons.cellphone},
      {'name': '游戏', 'icon': MdiIcons.gamepadVariant},
    ];

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择图标'),
          content: SizedBox(
            width: 300,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final iconData = icons[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, 'MdiIcons.${iconData['icon'].toString().substring(8)}');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData['icon'] as IconData, size: 32),
                      const SizedBox(height: 4),
                      Text(iconData['name'] as String, style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _selectRepeatFrequency(BuildContext context) async {
    final frequency = await showDialog<RepeatFrequency>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).repeatFrequency),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: RepeatFrequency.values.map((frequency) {
              return ListTile(
                title: Text(_getRepeatFrequencyDisplayName(context, frequency)),
                onTap: () => Navigator.pop(context, frequency),
              );
            }).toList(),
          ),
        );
      },
    );
    if (frequency != null) {
      setState(() {
        _repeatFrequency = frequency;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addHabit),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.habitName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.pleaseEnterHabitName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: loc.description,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(loc.startDate),
              subtitle: Text(_startDate?.toString().split(' ')[0] ?? loc.selectDate),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(loc.startTime),
              subtitle: Text(_startTime.format(context)),
              onTap: () => _selectTime(context),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('图标'),
              subtitle: Text(_selectedIcon?.replaceAll('MdiIcons.', '') ?? '目标'),
              onTap: () async {
                final icon = await _selectIcon(context);
                if (icon != null) {
                  setState(() {
                    _selectedIcon = icon;
                  });
                }
              },
            ),
            SwitchListTile(
              title: Text(loc.setReminder),
              value: _isReminderEnabled,
              onChanged: (value) {
                setState(() {
                  _isReminderEnabled = value;
                });
              },
            ),
            if (_isReminderEnabled) ...[
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(loc.reminderTime),
                subtitle: Text(_reminderTime?.format(context) ?? loc.setReminder),
                onTap: () => _selectReminderTime(context),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.repeat),
              title: Text(loc.repeatFrequency),
              subtitle: Text(_getRepeatFrequencyDisplayName(context, _repeatFrequency)),
              onTap: () => _selectRepeatFrequency(context),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(loc.saveHabit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}