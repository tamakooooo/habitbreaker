# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application for helping users break bad habits through a countdown approach. The app is built with Flutter 3.24.0 and Dart 3.2+, following Material Design guidelines. It uses Riverpod for state management, Hive for local storage, GoRouter for navigation, and other popular Flutter packages.

The app focuses on 戒断不良习惯 (breaking bad habits) by allowing users to set start dates and target end dates for habits they want to 戒断. Users can track their progress with countdown timers showing days remaining and time remaining for each habit.

## Project Structure

```
lib/
├── config/              # Configuration files (constants, themes)
├── core/                # Core functionality (utils, services, exceptions, router)
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── habits/         # Habit management
│   ├── statistics/     # Statistics and analytics
│   └── settings/       # Application settings
├── models/              # Data models
├── screens/             # Main application screens
├── widgets/             # Custom reusable widgets
├── localization/        # Internationalization
└── main.dart           # Application entry point

test/
├── *.dart              # Unit and widget tests for corresponding features
```

## Key Dependencies

- State Management: flutter_riverpod ^2.4.9
- Local Database: hive ^2.2.3 with hive_flutter ^1.1.0
- Navigation: go_router ^14.2.3
- UI & Screen Adaptation: flutter_screenutil ^5.9.0
- Network: dio ^5.4.0
- Charts: fl_chart ^0.63.0
- Notifications: flutter_local_notifications ^19.4.0
- Background Tasks: workmanager ^0.7.0
- Storage: flutter_secure_storage ^8.0.0, shared_preferences ^2.2.0
- Internationalization: intl ^0.19.0, flutter_localizations
- Utilities: logger ^2.0.2, equatable ^2.0.5, json_annotation ^4.8.1

## Development Commands

### Running the App
```bash
flutter run
```

### Building the App
```bash
# Debug build
flutter build

# Release build for Android
flutter build apk

# Release build for iOS
flutter build ios
```

### Testing
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/habit_model_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Generation
```bash
# Run build runner for Hive and JSON serialization
dart run build_runner build
dart run build_runner watch
```

### Linting
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .
```

## Architecture Patterns

The app follows a feature-first architecture with clear separation of concerns:
1. Each feature is contained in its own directory under `lib/features/`
2. State management is handled by Riverpod providers
3. Local data persistence uses Hive for structured data
4. Navigation is managed by GoRouter with declarative routes
5. Business logic is separated from UI components
6. Internationalization support for multiple languages (English and Chinese)
7. Background task processing with workmanager
8. Local notifications for habit reminders
9. Countdown functionality for tracking 戒断 progress with real-time timers
10. Progress visualization with linear progress indicators

## Important Constants

Key application constants are defined in `lib/config/constants.dart`:
- App name and version
- API endpoints
- Storage keys for shared preferences and Hive boxes
- Notification channels
- Time constants and pagination settings

## Habit Model

The Habit model (`lib/models/habit.dart`) includes the following fields:
- id: Unique identifier for the habit
- name: Name of the habit to break
- description: Description of the habit
- createdDate: Date when the habit was created
- startDate: Date when the 戒断 process starts
- targetEndDate: Target date for completing the 戒断
- isCompleted: Whether the habit 戒断 is completed
- streakCount: Number of consecutive days the habit has been avoided
- completionDates: List of dates when the habit was marked as avoided
- stage: Current戒断 stage (hours24, days3, week1, month1, quarter1, year1)
- currentStageStartDate: Start date of current戒断 stage
- currentStageEndDate: End date of current戒断 stage

## Testing Approach

The project uses Flutter's built-in testing framework:
- Widget tests for UI components (`test/` directory)
- Unit tests for business logic and models
- Integration tests for complex workflows
- Riverpod provider testing with ProviderContainer

Test files follow the naming convention `[feature]_test.dart` and are located in the `test/` directory.

### Running Tests
- Run all tests: `flutter test`
- Run specific test file: `flutter test test/[filename]_test.dart`
- Run with coverage: `flutter test --coverage`

### Test Structure
- `test/habit_model_test.dart` - Tests for the Habit model
- `test/home_screen_test.dart` - Tests for the Home screen
- `test/habit_list_screen_test.dart` - Tests for the Habit list screen
- `test/statistics_screen_test.dart` - Tests for the Statistics screen

### Additional Test Considerations
- Test countdown timer functionality for accuracy
- Test habit creation and saving workflows
- Test navigation between screens
- Test internationalization with both English and Chinese locales

## Localization

The app supports multiple languages through the AppLocalizations system:
- English (default)
- Chinese (zh)

Localization files are located in `lib/localization/` and can be extended by adding new language entries to the AppLocalizations class.

Key localized strings include:
- App name and welcome messages
- Habit management texts (add, edit, view habits)
- Statistics and progress tracking
- Date selection and time remaining
- Navigation and UI elements

## Background Tasks

The app uses workmanager for background task processing:
- Habit reminder checks
- Daily habit resets
- Background task scheduling

## Notifications

The app uses flutter_local_notifications for local notifications:
- Habit reminders
- Achievement notifications
- Custom notification channels