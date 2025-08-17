import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for your habits'),
            value: true,
            onChanged: (bool value) {
              // Handle notification toggle
            },
          ),
          SwitchListTile(
            title: const Text('Enable Daily Reminders'),
            subtitle: const Text('Get daily habit reminders'),
            value: true,
            onChanged: (bool value) {
              // Handle daily reminder toggle
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: const Text('Set your daily reminder time'),
            trailing: const Text('9:00 AM'),
            onTap: () {
              // Show time picker
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Achievement Notifications'),
            subtitle: const Text('Get notified when you reach milestones'),
            value: true,
            onChanged: (bool value) {
              // Handle achievement notification toggle
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {
              // Show language selection
            },
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('System Default'),
            onTap: () {
              // Show theme selection
            },
          ),
        ],
      ),
    );
  }
}