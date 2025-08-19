# Icon Selector Widget

This document explains how to use the Icon Selector widget in the Habit Breaker app.

## Features

- Categorized icon display using the line_icons package
- Horizontal category selector
- Grid view of icons with names
- Scrollable interface to handle large numbers of icons
- Visual feedback for selected icons

## Usage

To use the Icon Selector widget in your screen:

```dart
IconSelector(
  onIconSelected: (iconName) {
    // Handle icon selection
    print('Selected icon: $iconName');
  },
)
```

## Implementation Details

The widget is implemented in `lib/widgets/icon_selector.dart` and includes:

1. Predefined icon categories (General, Nature, Technology, Arrows, Emojis, Food)
2. GridView with 4 columns for icon display
3. ChoiceChips for category selection
4. Visual feedback for selected icons

## Adding New Icons

To add new icons to a category:

1. Open `lib/widgets/icon_selector.dart`
2. Find the `_iconCategories` map
3. Add a new entry to the appropriate category list:

```dart
{'name': 'iconName', 'icon': LineIcons.iconName},
```

## Adding New Categories

To add a new category:

1. Open `lib/widgets/icon_selector.dart`
2. Find the `_iconCategories` map
3. Add a new key-value pair:

```dart
'CategoryName': [
  {'name': 'iconName', 'icon': LineIcons.iconName},
  // ... more icons
],
```

## Testing

A demo screen is available at `/icon-demo` route to test the icon selector functionality.

## Dependencies

This widget uses the `line_icons` package (version 2.0.3).