import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:habit_breaker_app/widgets/date_time_picker.dart';

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
  late DateTime _startDateTime;
  late String _selectedIcon;
  late Habit _originalHabit;
  late HabitStage _selectedStage;

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
                  'alarm',
                  'android',
                  'apple',
                  'beer',
                  'book',
                  'camera',
                  'car',
                  'coffee',
                  'cog',
                  'computer',
                  'diamond',
                  'dog',
                  'email',
                  'facebook',
                  'gamepad',
                  'github',
                  'heart',
                  'home',
                  'instagram',
                  'lightbulb',
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

  String _getStageDisplayName(BuildContext context, HabitStage stage) {
    final loc = AppLocalizations.of(context);
    switch (stage) {
      case HabitStage.hours24:
        return loc.stage24Hours;
      case HabitStage.days3:
        return loc.stage3Days;
      case HabitStage.week1:
        return loc.stage1Week;
      case HabitStage.month1:
        return loc.stage1Month;
      case HabitStage.month3:
        return loc.stage1Quarter;
      case HabitStage.year1:
        return loc.stage1Year;
    }
  }

  Future<void> _saveHabit(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      // Calculate target end date based on selected stage
      final targetEndDate = Habit.calculateStageEndDate(_startDateTime, _selectedStage);

      // Create updated habit with existing ID
      final updatedHabit = _originalHabit.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDateTime,
        icon: _selectedIcon,
        stage: _selectedStage,
        targetEndDate: targetEndDate,
        currentStageStartDate: _startDateTime,
        currentStageEndDate: targetEndDate,
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating habit: $error')));
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
          _startDateTime = habit.startDate;
          _selectedIcon = habit.icon;
          _selectedStage = habit.stage;
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
                        return AppLocalizations.of(
                          context,
                        ).pleaseEnterHabitName;
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
                    trailing: Icon(
                      _selectedIcon == 'default_icon'
                          ? Icons.star
                          : MdiIcons.fromString(_selectedIcon),
                    ),
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
                      leading: const Icon(Icons.timeline),
                      title: Text(AppLocalizations.of(context).targetStage),
                      subtitle: Text(_getStageDisplayName(context, _selectedStage)),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.hours24)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.hours24;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.days3)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.days3;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.week1)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.week1;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.month1)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.month1;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.month3)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.month3;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(_getStageDisplayName(context, HabitStage.year1)),
                                    onTap: () {
                                      setState(() {
                                        _selectedStage = HabitStage.year1;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DateTimePicker(
                        initialDateTime: _startDateTime,
                        onDateTimeSelected: (newDateTime) {
                          setState(() {
                            _startDateTime = newDateTime;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading habit: $error'))),
    );
  }
}
