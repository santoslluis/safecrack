import '../models/graph_models.dart';
import '../models/safe_models.dart';

enum GameState {
  idle,
  playing,
  success,
  failed,
}

enum MoveResult {
  exploring,
  nodeEntered,
  trapHit,
  goalReached,
  noMatch,
}

class GameEngine {
  final Safe safe;
  
  GameState _state = GameState.idle;
  String _currentNodeId = '';
  int _accumulatedDelta = 0;
  int _attempts = 0;
  DateTime? _startTime;
  final List<String> _visitedNodes = [];

  GameEngine(this.safe) {
    _currentNodeId = safe.graph.startNodeId;
  }

  GameState get state => _state;
  int get attempts => _attempts;
  int get accumulatedDelta => _accumulatedDelta;
  GraphNode get currentNode => safe.graph.getNode(_currentNodeId)!;
  int get par => safe.par;
  
  Duration get elapsedTime {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  void startGame() {
    _state = GameState.playing;
    _currentNodeId = safe.graph.startNodeId;
    _accumulatedDelta = 0;
    _attempts = 0;
    _startTime = DateTime.now();
    _visitedNodes.clear();
    _visitedNodes.add(_currentNodeId);
  }

  void reset() {
    _state = GameState.idle;
    _currentNodeId = safe.graph.startNodeId;
    _accumulatedDelta = 0;
    _attempts = 0;
    _startTime = null;
    _visitedNodes.clear();
  }

  MoveResult processRotation(int delta) {
    if (_state != GameState.playing) return MoveResult.noMatch;
    
    _accumulatedDelta += delta;
    
    final edge = safe.graph.findMatchingEdge(_currentNodeId, _accumulatedDelta);
    
    if (edge != null) {
      return _transitionToNode(edge.toNodeId);
    }
    
    return MoveResult.exploring;
  }

  MoveResult _transitionToNode(String nodeId) {
    final node = safe.graph.getNode(nodeId);
    if (node == null) return MoveResult.noMatch;
    
    _currentNodeId = nodeId;
    _accumulatedDelta = 0;
    
    if (!_visitedNodes.contains(nodeId)) {
      _visitedNodes.add(nodeId);
    }
    
    if (node.isGoal) {
      _state = GameState.success;
      return MoveResult.goalReached;
    }
    
    if (node.isTrap) {
      _attempts++;
      _currentNodeId = safe.graph.startNodeId;
      _accumulatedDelta = 0;
      return MoveResult.trapHit;
    }
    
    return MoveResult.nodeEntered;
  }

  void registerMistake() {
    _attempts++;
  }

  AttemptResult getResult() {
    return AttemptResult(
      safeId: safe.id,
      attempts: _attempts,
      time: elapsedTime,
      success: _state == GameState.success,
      timestamp: DateTime.now(),
    );
  }

  String getScoreLabel() {
    final diff = _attempts - par;
    if (diff == 0) return 'PAR';
    if (diff < 0) return '${diff.abs()} under par';
    return '$diff over par';
  }
}
