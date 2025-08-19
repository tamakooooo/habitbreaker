import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/core/providers/habit_providers.dart';
import 'package:habit_breaker_app/widgets/habit_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('戒断不良习惯'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: habitsAsync.when(
          data: (habits) {
            if (habits.isEmpty) {
              return const Center(
                child: Text('还没有戒断。添加你的第一个戒断！'),
              );
            }
            return ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitCard(
                  habit: habits[index],
                  onTap: () {
                    context.push('/habits/${habits[index].id}');
                  },
                  onCheck: () {
                    // Handle habit completion
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/habits/add'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
}