import 'dart:async';
import 'package:flutter/material.dart';
import '../core/game_engine.dart';
import '../models/safe_models.dart';
import '../services/haptic_service.dart';
import '../services/input_handler.dart';
import '../services/storage_service.dart';
import '../ui/dial_widget.dart';

class GameScreen extends StatefulWidget {
  final Safe safe;
  final VoidCallback? onComplete;

  const GameScreen({
    super.key,
    required this.safe,
    this.onComplete,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameEngine _engine;
  late HapticService _haptics;
  late StorageService _storage;
  
  double _dialRotation = 0;
  int? _feedbackState;
  Timer? _feedbackTimer;
  Timer? _timeTimer;
  String _elapsedTimeStr = '00:00.00';
  PersonalBest? _personalBest;

  @override
  void initState() {
    super.initState();
    _engine = GameEngine(widget.safe);
    _haptics = HapticService();
    _storage = StorageService();
    _loadPersonalBest();
    _startGame();
  }

  Future<void> _loadPersonalBest() async {
    final best = await _storage.getPersonalBest(widget.safe.id);
    if (mounted) {
      setState(() {
        _personalBest = best;
      });
    }
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _engine.startGame();
    _timeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _engine.state == GameState.playing) {
        setState(() {
          _elapsedTimeStr = _formatDuration(_engine.elapsedTime);
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    final millis = (d.inMilliseconds % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(2, '0')}';
  }

  void _handleRotation(int delta) {
    if (_engine.state != GameState.playing) return;

    setState(() {
      _dialRotation += delta * 2;
    });

    final result = _engine.processRotation(delta);
    
    switch (result) {
      case MoveResult.exploring:
        if (delta.abs() > 3) {
          _haptics.tick();
        }
        break;
      case MoveResult.nodeEntered:
        _haptics.play(HapticType.medium);
        _showFeedback(0);
        break;
      case MoveResult.trapHit:
        _haptics.error();
        _showFeedback(-1);
        setState(() {
          _dialRotation = 0;
        });
        break;
      case MoveResult.goalReached:
        _haptics.success();
        _showFeedback(1);
        _timeTimer?.cancel();
        _onSuccess();
        break;
      case MoveResult.noMatch:
        break;
    }
  }

  Future<void> _onSuccess() async {
    final result = _engine.getResult();
    await _storage.savePersonalBest(result);
    await _loadPersonalBest();
    _showSuccessDialog(result);
  }

  void _showFeedback(int state) {
    _feedbackTimer?.cancel();
    setState(() {
      _feedbackState = state;
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _feedbackState = null;
        });
      }
    });
  }

  void _showSuccessDialog(AttemptResult result) {
    final isNewRecord = _personalBest != null && 
        (result.attempts < _personalBest!.bestAttempts ||
         (result.attempts == _personalBest!.bestAttempts && result.time < _personalBest!.bestTime));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Column(
          children: [
            const Text(
              'SAFE OPENED!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (isNewRecord)
              const Text(
                'NEW RECORD!',
                style: TextStyle(color: Colors.amber, fontSize: 14),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_open, 
              size: 64, 
              color: isNewRecord ? Colors.amber : Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              widget.safe.name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            _buildStatRow('Attempts', '${result.attempts}'),
            _buildStatRow('PAR', '${widget.safe.par}'),
            _buildStatRow('Score', _engine.getScoreLabel()),
            _buildStatRow('Time', result.timeFormatted),
            if (_personalBest != null) ...[
              const Divider(color: Colors.grey),
              _buildStatRow('Best Attempts', '${_personalBest!.bestAttempts}'),
              _buildStatRow('Best Time', _formatDuration(_personalBest!.bestTime)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('TRY AGAIN'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              widget.onComplete?.call();
            },
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _dialRotation = 0;
      _feedbackState = null;
    });
    _engine.reset();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialSize = size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.safe.name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: RotaryInputWidget(
        onRotation: _handleRotation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoChip('PAR ${widget.safe.par}', Colors.blue),
                  const SizedBox(width: 16),
                  _buildInfoChip('Attempts: ${_engine.attempts}', 
                    _engine.attempts > widget.safe.par ? Colors.red : Colors.green),
                ],
              ),
              if (_personalBest != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Best: ${_personalBest!.bestAttempts} attempts',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              DialWidget(
                rotation: _dialRotation,
                size: dialSize,
                primaryColor: Colors.grey,
                accentColor: Colors.deepPurple,
                isActive: _engine.state == GameState.playing,
                feedbackState: _feedbackState,
              ),
              const SizedBox(height: 24),
              Text(
                _elapsedTimeStr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Swipe or scroll to rotate',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
