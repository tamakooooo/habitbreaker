import 'package:flutter/material.dart';
import 'package:habit_breaker_app/widgets/icon_selector.dart';

class IconDemoScreen extends StatefulWidget {
  const IconDemoScreen({super.key});

  @override
  _IconDemoScreenState createState() => _IconDemoScreenState();
}

class _IconDemoScreenState extends State<IconDemoScreen> {
  String _selectedIcon = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon Selector Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Icon:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_selectedIcon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose an Icon:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: IconSelector(
                onIconSelected: (iconName) {
                  setState(() {
                    _selectedIcon = iconName;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
