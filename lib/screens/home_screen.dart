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
            
            // 使用自定义的可滚动卡片布局，适配不同屏幕尺寸
            return _buildHabitCardList(context, habits);
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                // Navigate to habit list
                context.push('/habits');
              },
              child: const Text('查看我的戒断'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to statistics
                context.push('/statistics');
              },
              child: const Text('查看统计'),
            ),
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
  
  Widget _buildHabitCardList(BuildContext context, List habits) {
    // 获取屏幕宽度以决定布局方式
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 根据屏幕宽度调整卡片布局
    if (screenWidth > 600) {
      // 大屏幕设备（平板）使用双列网格布局
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return HabitCard(
            habit: habits[index],
            isCompact: true, // 在网格布局中使用紧凑版本
            onTap: () {
              // 使用go方法导航，避免返回时重建页面
              context.go('/habits/${habits[index].id}');
            },
            onCheck: () {
              // Handle habit completion
            },
          );
        },
      );
    } else {
      // 手机屏幕使用单列列表布局
      return ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: HabitCard(
              habit: habits[index],
              isCompact: false, // 在列表布局中使用标准版本
              onTap: () {
                context.go('/habits/${habits[index].id}');
              },
              onCheck: () {
                // Handle habit completion
              },
            ),
          );
        },
      );
    }
  }
}