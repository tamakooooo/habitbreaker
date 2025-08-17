import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';

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
  DateTime? _targetEndDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }
      
      if (_targetEndDate == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a target end date')),
        );
        return;
      }

      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        createdDate: DateTime.now(),
        startDate: _startDate!,
        targetEndDate: _targetEndDate!,
      );

      // Save habit using provider
      final habitService = ref.read(habitServiceProvider);
      try {
        await habitService.createHabit(habit);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit added successfully!')),
        );
        
        // Navigate back to the habit list
        if (!mounted) return;
        context.pop();
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving habit: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addHabit),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                    return 'Please enter a habit name';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(AppLocalizations.of(context).startDate),
                subtitle: Text(
                  _startDate == null
                      ? AppLocalizations.of(context).notSelected
                      : '${_startDate!.year}-${_startDate!.month}-${_startDate!.day}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
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
              const SizedBox(height: 16),
              ListTile(
                title: Text(AppLocalizations.of(context).targetEndDate),
                subtitle: Text(
                  _targetEndDate == null
                      ? AppLocalizations.of(context).notSelected
                      : '${_targetEndDate!.year}-${_targetEndDate!.month}-${_targetEndDate!.day}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _targetEndDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}