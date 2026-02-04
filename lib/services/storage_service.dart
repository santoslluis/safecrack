import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/safe_models.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<PersonalBest?> getPersonalBest(String safeId) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final key = 'personal_best_$safeId';
    final data = prefs.getString(key);
    
    if (data == null) return null;
    
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      return PersonalBest(
        safeId: json['safeId'] as String,
        bestAttempts: json['bestAttempts'] as int,
        bestTime: Duration(milliseconds: json['bestTimeMs'] as int),
        achievedAt: DateTime.parse(json['achievedAt'] as String),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> savePersonalBest(AttemptResult result) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final key = 'personal_best_${result.safeId}';
    
    final existing = await getPersonalBest(result.safeId);
    
    bool shouldSave = existing == null;
    if (existing != null) {
      if (result.attempts < existing.bestAttempts) {
        shouldSave = true;
      } else if (result.attempts == existing.bestAttempts && 
                 result.time < existing.bestTime) {
        shouldSave = true;
      }
    }
    
    if (shouldSave) {
      final data = jsonEncode({
        'safeId': result.safeId,
        'bestAttempts': result.attempts,
        'bestTimeMs': result.time.inMilliseconds,
        'achievedAt': result.timestamp.toIso8601String(),
      });
      await prefs.setString(key, data);
    }
  }

  Future<List<String>> getUnlockedSafeIds() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getStringList('unlocked_safes') ?? ['free_1'];
  }

  Future<void> unlockSafe(String safeId) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final unlocked = await getUnlockedSafeIds();
    if (!unlocked.contains(safeId)) {
      unlocked.add(safeId);
      await prefs.setStringList('unlocked_safes', unlocked);
    }
  }

  Future<bool> isPremiumUnlocked() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getBool('premium_unlocked') ?? false;
  }

  Future<void> setPremiumUnlocked(bool value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool('premium_unlocked', value);
  }

  Future<Map<String, PersonalBest>> getAllPersonalBests() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final result = <String, PersonalBest>{};
    
    for (final key in prefs.getKeys()) {
      if (key.startsWith('personal_best_')) {
        final safeId = key.replaceFirst('personal_best_', '');
        final best = await getPersonalBest(safeId);
        if (best != null) {
          result[safeId] = best;
        }
      }
    }
    
    return result;
  }
}
