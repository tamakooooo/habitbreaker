# Habit Breaker App

A Flutter mobile application for helping users break bad habits through a countdown approach.

## Getting Started

This project is a Flutter application that helps users track their progress in breaking bad habits. The app allows users to set start dates and target end dates for habits they want to break, and tracks their progress with countdown timers.

### Prerequisites

- Flutter 3.35.1 or higher
- Dart 3.2.0 or higher
- Android Studio or VS Code with Flutter plugins

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Development

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

# Run tests with coverage
flutter test --coverage
```

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment:

- Automated testing on every push and pull request
- APK building for Android releases
- Automatic release creation for tagged commits
- Latest build updates for main branch pushes

The workflow is defined in `.github/workflows/flutter-ci-cd.yml`.

### Release Process

1. **Tagged Releases**: Create a tag with the pattern `v*` (e.g., `v1.0.0`) to automatically create a GitHub release with the APK
2. **Latest Build**: Every push to the main branch automatically updates the "Latest Build" release with the newest APK

## Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
