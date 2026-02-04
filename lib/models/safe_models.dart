import 'graph_models.dart';

enum SafeCategory {
  free,
  premium,
  weekly,
}

class Safe {
  final String id;
  final String name;
  final SafeCategory category;
  final SafeGraph graph;
  final int order;
  final bool isUnlocked;
  final String? weekId;

  const Safe({
    required this.id,
    required this.name,
    required this.category,
    required this.graph,
    required this.order,
    this.isUnlocked = false,
    this.weekId,
  });

  int get par => graph.par;

  Safe copyWith({bool? isUnlocked}) {
    return Safe(
      id: id,
      name: name,
      category: category,
      graph: graph,
      order: order,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      weekId: weekId,
    );
  }
}

class AttemptResult {
  final String safeId;
  final int attempts;
  final Duration time;
  final bool success;
  final DateTime timestamp;

  const AttemptResult({
    required this.safeId,
    required this.attempts,
    required this.time,
    required this.success,
    required this.timestamp,
  });

  int get score => attempts;

  String get timeFormatted {
    final minutes = time.inMinutes;
    final seconds = time.inSeconds % 60;
    final millis = (time.inMilliseconds % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(2, '0')}';
  }
}

class PersonalBest {
  final String safeId;
  final int bestAttempts;
  final Duration bestTime;
  final DateTime achievedAt;

  const PersonalBest({
    required this.safeId,
    required this.bestAttempts,
    required this.bestTime,
    required this.achievedAt,
  });

  bool isBetterThan(AttemptResult result) {
    if (result.attempts > bestAttempts) return true;
    if (result.attempts < bestAttempts) return false;
    return result.time > bestTime;
  }
}

class RankingEntry {
  final String odId;
  final String safeId;
  final String playerName;
  final int attempts;
  final Duration time;
  final int rank;

  const RankingEntry({
    required this.odId,
    required this.safeId,
    required this.playerName,
    required this.attempts,
    required this.time,
    required this.rank,
  });
}
