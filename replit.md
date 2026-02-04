# SafeCrack - Safe Cracking Game

## Overview
SafeCrack is a minimalist, sensory game for smartwatch (and mobile) where players open safes by rotating a dial. The game uses graph-based mechanics where players navigate through nodes using precise rotations, with haptic feedback guiding them instead of visible numbers.

## Project Structure
```
lib/
├── core/
│   └── game_engine.dart      # Main game logic, state machine, graph traversal
├── models/
│   ├── graph_models.dart     # GraphNode, GraphEdge, SafeGraph
│   └── safe_models.dart      # Safe, AttemptResult, PersonalBest, RankingEntry
├── services/
│   ├── input_handler.dart    # Rotary input, gesture handling
│   └── haptic_service.dart   # Haptic feedback (tick, success, error)
├── ui/
│   └── dial_widget.dart      # Custom painted dial with rotation indicator
├── screens/
│   ├── safe_selection_screen.dart  # Safe grid, FREE/PREMIUM tabs
│   └── game_screen.dart      # Main gameplay screen
├── data/
│   └── sample_safes.dart     # 9 free + 9 premium sample safes
└── main.dart                 # App entry point
```

## Technology Stack
- **Framework**: Flutter 3.32.0
- **Language**: Dart 3.8.0
- **Target Platforms**: Web, iOS, Android (Watch support via platform-specific input)

## Game Mechanics
- **Graph-based safe opening**: Each safe has a directed graph with start, intermediate, goal, and trap nodes
- **Rotary input**: Players rotate the dial (swipe/scroll on mobile, Digital Crown on watch)
- **Golf scoring**: PAR system with attempt counting (fewer attempts = better)
- **Haptic feedback**: Tick on rotation, heavy vibration on traps, success pattern on goal
- **Progressive unlock**: Complete safes to unlock the next one

## Safe Categories
1. **FREE**: 9 safes, unlocked sequentially
2. **PREMIUM**: 9 additional safes (all unlock together with premium flag)
3. **WEEKLY**: Special weekly challenges (structure ready, backend not implemented)

## Running the App
The workflow builds Flutter web and serves on port 5000:
```bash
flutter build web --release && cd build/web && python -m http.server 5000 --bind 0.0.0.0
```

### Key Commands
- `flutter pub get` - Install dependencies
- `flutter build web --release` - Build for production
- `flutter run -d chrome` - Run in Chrome browser

## Recent Changes
- Created complete SafeCrack game from Flutter demo app
- Implemented graph-based game engine
- Added rotary input handler with gesture support
- Created haptic feedback service
- Built dial widget with custom painter
- Implemented safe selection screen with FREE/PREMIUM tabs
- Added 9 free safes and 9 premium safes with varied difficulty
- Fixed SDK constraint for Flutter 3.32.0 compatibility

## User Preferences
(No preferences recorded yet)

## Deployment
Configured for static deployment using `build/web` directory.
