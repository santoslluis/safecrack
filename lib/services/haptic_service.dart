import 'package:flutter/services.dart';

enum HapticType {
  tick,
  light,
  medium,
  heavy,
  success,
  warning,
  error,
}

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _enabled = true;

  bool get isEnabled => _enabled;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> play(HapticType type) async {
    if (!_enabled) return;

    switch (type) {
      case HapticType.tick:
        await HapticFeedback.selectionClick();
        break;
      case HapticType.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case HapticType.success:
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.lightImpact();
        break;
      case HapticType.warning:
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.mediumImpact();
        break;
      case HapticType.error:
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  Future<void> tick() => play(HapticType.tick);
  Future<void> success() => play(HapticType.success);
  Future<void> error() => play(HapticType.error);
  Future<void> warning() => play(HapticType.warning);
}
