# Safecrack - Flutter Web Application

## Overview
This is a Flutter web application that was imported from a GitHub repository. The project is built using Flutter and Dart, targeting web deployment.

## Project Structure
- `lib/` - Main Dart source code
  - `main.dart` - Application entry point with a demo counter app
- `web/` - Web-specific files (index.html, manifest, icons)
- `android/`, `ios/`, `macos/` - Platform-specific directories (not used for web)
- `test/` - Unit tests
- `pubspec.yaml` - Flutter/Dart dependencies and project configuration
- `build/web/` - Generated release build output

## Technology Stack
- **Framework**: Flutter 3.32.0
- **Language**: Dart 3.8.0
- **Target Platform**: Web

## Development
The app runs a Flutter web release build served via Python's HTTP server.

### Running the App
The workflow builds the Flutter web application and serves it on port 5000:
```bash
flutter build web --release && cd build/web && python -m http.server 5000 --bind 0.0.0.0
```

### Key Commands
- `flutter pub get` - Install dependencies
- `flutter build web --release` - Build for production
- `flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0` - Run in debug mode

## Deployment
The app is configured for static deployment. The `build/web` directory contains all the static files needed for deployment.

## Recent Changes
- Fixed syntax errors in lib/main.dart (ColorScheme.fromSeed and MainAxisAlignment.center)
- Updated SDK constraint in pubspec.yaml to ^3.8.0 for Flutter 3.32.0 compatibility
- Configured workflow for web deployment on port 5000

## User Preferences
(No preferences recorded yet)
