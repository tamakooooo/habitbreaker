import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final String habitId;

  const EditHabitScreen({super.key, required this.habitId});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late String _selectedIcon;
  late Habit _originalHabit;

  @override
  void initState() {
    super.initState();
    // We'll initialize the controllers and other variables after fetching the habit
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<String?> _selectIcon(BuildContext context) async {
    final selectedIcon = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).selectIcon),
          content: SizedBox(
            width: 300,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 20, // Show first 20 icons as an example
              itemBuilder: (BuildContext context, int index) {
                // Example icons - in a real app, you might want to show more icons
                final icons = [
                  'alarm', 'android', 'apple', 'beer', 'book', 'camera', 'car', 'coffee',
                  'cog', 'computer', 'diamond', 'dog', 'email', 'facebook', 'gamepad', 'github',
                  'heart', 'home', 'instagram', 'lightbulb'
                ];
                
                final iconData = MdiIcons.fromString(icons[index]);
                
                return IconButton(
                  icon: Icon(iconData),
                  onPressed: () {
                    Navigator.of(context).pop(icons[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
    
    return selectedIcon;
  }

  Future<void> _saveHabit(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      // Combine date and time
      final startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      
      // Create updated habit with existing ID
      final updatedHabit = _originalHabit.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: startDateTime,
        icon: _selectedIcon,
      );

      // Update habit using provider
      final habitService = ref.read(habitServiceProvider);
      try {
        await habitService.updateHabit(updatedHabit);
        
        // Invalidate habits provider to refresh the list
        ref.invalidate(habitsProvider);
        ref.invalidate(habitProvider(_originalHabit.id));
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully!')),
        );
        
        // Navigate back to the habit detail page
        if (!mounted) return;
        context.pop();
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating habit: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the habit using the habitId
    final habitAsync = ref.watch(habitProvider(widget.habitId));
    
    return habitAsync.when(
      data: (habit) {
        // Initialize the state with habit data if not already done
        if (_nameController.text.isEmpty) {
          _originalHabit = habit;
          _nameController.text = habit.name;
          _descriptionController.text = habit.description;
          _startDate = habit.startDate;
          _startTime = TimeOfDay.fromDateTime(habit.startDate);
          _selectedIcon = habit.icon;
        }
        
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).editHabit),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _saveHabit(ref),
                tooltip: AppLocalizations.of(context).save,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).habitName,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).pleaseEnterHabitName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).description,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppLocalizations.of(context).icon),
                    subtitle: Text(_selectedIcon),
                    trailing: Icon(_selectedIcon == 'default_icon' ? Icons.star : MdiIcons.fromString(_selectedIcon)),
                    onTap: () async {
                      final selectedIcon = await _selectIcon(context);
                      if (selectedIcon != null) {
                        setState(() {
                          _selectedIcon = selectedIcon;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(AppLocalizations.of(context).startDate),
                      subtitle: Text(
                        '${_startDate.year}-${_startDate.month}-${_startDate.day}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppLocalizations.of(context).startTime),
                    subtitle: Text(
                      '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                      );
                      if (time != null) {
                        setState(() {
                          _startTime = time;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading habit: $error')),
      ),
    );
  }
}