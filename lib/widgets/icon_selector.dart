import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class IconSelector extends StatefulWidget {
  final Function(String) onIconSelected;

  const IconSelector({super.key, required this.onIconSelected});

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  // Define categories for icons
  final Map<String, List<Map<String, dynamic>>> _iconCategories = {
    'General': [
      {'name': 'home', 'icon': LineIcons.home},
      {'name': 'user', 'icon': LineIcons.user},
      {'name': 'cog', 'icon': LineIcons.cog},
      {'name': 'heart', 'icon': LineIcons.heart},
      {'name': 'star', 'icon': LineIcons.star},
      {'name': 'search', 'icon': LineIcons.search},
      {'name': 'bell', 'icon': LineIcons.bell},
      {'name': 'envelope', 'icon': LineIcons.envelope},
    ],
    'Nature': [
      {'name': 'tree', 'icon': LineIcons.tree},
      {'name': 'leaf', 'icon': LineIcons.leaf},
      {'name': 'sun', 'icon': LineIcons.sun},
      {'name': 'moon', 'icon': LineIcons.moon},
      {'name': 'cloud', 'icon': LineIcons.cloud},
      {'name': 'bolt', 'icon': LineIcons.lightningBolt},
      {'name': 'snowflake', 'icon': LineIcons.snowflake},
      {'name': 'fire', 'icon': LineIcons.fire},
    ],
    'Technology': [
      {'name': 'laptop', 'icon': LineIcons.laptop},
      {'name': 'mobile', 'icon': LineIcons.mobilePhone},
      {'name': 'tablet', 'icon': LineIcons.tablet},
      {'name': 'wifi', 'icon': LineIcons.wifi},
      {'name': 'bluetooth', 'icon': LineIcons.bluetooth},
      {'name': 'camera', 'icon': LineIcons.camera},
      {'name': 'print', 'icon': LineIcons.print},
      {'name': 'save', 'icon': LineIcons.save},
    ],
    'Arrows': [
      {'name': 'arrowUp', 'icon': LineIcons.arrowUp},
      {'name': 'arrowDown', 'icon': LineIcons.arrowDown},
      {'name': 'arrowLeft', 'icon': LineIcons.arrowLeft},
      {'name': 'arrowRight', 'icon': LineIcons.arrowRight},
      {'name': 'chevronUp', 'icon': LineIcons.chevronUp},
      {'name': 'chevronDown', 'icon': LineIcons.chevronDown},
      {'name': 'chevronLeft', 'icon': LineIcons.chevronLeft},
      {'name': 'chevronRight', 'icon': LineIcons.chevronRight},
    ],
    'Emojis': [
      {'name': 'smile', 'icon': LineIcons.smilingFaceWithHeartEyes},
      {'name': 'frown', 'icon': LineIcons.frowningFaceWithOpenMouth},
      {'name': 'meh', 'icon': LineIcons.neutralFace},
      {'name': 'mehBlank', 'icon': LineIcons.neutralFace},
      {'name': 'angry', 'icon': LineIcons.angryFace},
      {'name': 'grin', 'icon': LineIcons.grinningFaceWithSmilingEyes},
      {'name': 'laugh', 'icon': LineIcons.faceWithTearsOfJoy},
      {'name': 'surprise', 'icon': LineIcons.frowningFaceWithOpenMouth},
    ],
    'Food': [
      {'name': 'apple', 'icon': LineIcons.apple},
      {'name': 'carrot', 'icon': LineIcons.carrot},
      {'name': 'lemon', 'icon': LineIcons.lemon},
      {'name': 'pepperHot', 'icon': LineIcons.hotPepper},
      {'name': 'pizzaSlice', 'icon': LineIcons.pizzaSlice},
      {'name': 'iceCream', 'icon': LineIcons.iceCream},
      {'name': 'coffee', 'icon': LineIcons.coffee},
      {'name': 'wineBottle', 'icon': LineIcons.wineBottle},
    ],
  };

  String _selectedCategory = 'General';
  String _selectedIcon = 'home';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category selector
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _iconCategories.keys.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Icon grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _iconCategories[_selectedCategory]!.length,
            itemBuilder: (context, index) {
              final iconData = _iconCategories[_selectedCategory]![index];
              final isSelected = _selectedIcon == iconData['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = iconData['name'];
                  });
                  widget.onIconSelected(iconData['name']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData['icon'], size: 30),
                      const SizedBox(height: 4),
                      Text(
                        iconData['name'],
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}