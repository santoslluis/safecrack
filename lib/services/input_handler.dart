import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

typedef RotationCallback = void Function(int delta);

enum InputMode {
  digitalCrown,
  rotaryInput,
  gesture,
}

class InputHandler {
  final RotationCallback onRotation;
  final VoidCallback? onTap;
  
  InputMode _mode = InputMode.gesture;
  double _gestureAccumulatorX = 0;
  double _gestureAccumulatorY = 0;
  static const double _gestureThreshold = 10.0;
  static const int _deltaMultiplier = 5;

  InputHandler({
    required this.onRotation,
    this.onTap,
  });

  InputMode get mode => _mode;

  void setMode(InputMode mode) {
    _mode = mode;
  }

  void handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final delta = event.scrollDelta.dy;
      final rotationDelta = -(delta / 10).round();
      if (rotationDelta != 0) {
        onRotation(rotationDelta);
      }
    }
  }

  void handlePanUpdate(DragUpdateDetails details) {
    _gestureAccumulatorX += details.delta.dx;
    _gestureAccumulatorY -= details.delta.dy;
    
    final combinedDelta = _gestureAccumulatorX + _gestureAccumulatorY;
    
    if (combinedDelta.abs() >= _gestureThreshold) {
      final ticks = (combinedDelta / _gestureThreshold).truncate();
      onRotation(ticks * _deltaMultiplier);
      _gestureAccumulatorX = _gestureAccumulatorX % _gestureThreshold;
      _gestureAccumulatorY = _gestureAccumulatorY % _gestureThreshold;
    }
  }

  void handleVerticalDrag(DragUpdateDetails details) {
    _gestureAccumulatorY -= details.delta.dy;
    
    if (_gestureAccumulatorY.abs() >= _gestureThreshold) {
      final ticks = (_gestureAccumulatorY / _gestureThreshold).truncate();
      onRotation(ticks * _deltaMultiplier);
      _gestureAccumulatorY = _gestureAccumulatorY % _gestureThreshold;
    }
  }

  void handleHorizontalDrag(DragUpdateDetails details) {
    _gestureAccumulatorX += details.delta.dx;
    
    if (_gestureAccumulatorX.abs() >= _gestureThreshold) {
      final ticks = (_gestureAccumulatorX / _gestureThreshold).truncate();
      onRotation(ticks * _deltaMultiplier);
      _gestureAccumulatorX = _gestureAccumulatorX % _gestureThreshold;
    }
  }

  void resetAccumulator() {
    _gestureAccumulatorX = 0;
    _gestureAccumulatorY = 0;
  }

  void handleTap() {
    onTap?.call();
  }
}

class RotaryInputWidget extends StatefulWidget {
  final Widget child;
  final RotationCallback onRotation;
  final VoidCallback? onTap;

  const RotaryInputWidget({
    super.key,
    required this.child,
    required this.onRotation,
    this.onTap,
  });

  @override
  State<RotaryInputWidget> createState() => _RotaryInputWidgetState();
}

class _RotaryInputWidgetState extends State<RotaryInputWidget> {
  late InputHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = InputHandler(
      onRotation: widget.onRotation,
      onTap: widget.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handler.handlePointerSignal,
      child: GestureDetector(
        onPanUpdate: _handler.handlePanUpdate,
        onVerticalDragUpdate: _handler.handleVerticalDrag,
        onTap: _handler.handleTap,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
    );
  }
}
