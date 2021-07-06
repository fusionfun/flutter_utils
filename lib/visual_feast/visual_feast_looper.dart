import 'package:flutter/scheduler.dart';

/// Created by @RealCradle on 2021/7/7
///
class VisualFeastLooper {
  final Function callback;
  Duration previous = Duration.zero;
  late Ticker _ticker;

  VisualFeastLooper(this.callback) {
    _ticker = Ticker(_tick);
  }

  void _tick(Duration timestamp) {
    final double dt = _computeDeltaT(timestamp);
    callback(dt);
  }

  double _computeDeltaT(Duration now) {
    Duration delta = now - previous;
    if (previous == Duration.zero) {
      delta = Duration.zero;
    }
    previous = now;

    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  bool get isActive => _ticker.isActive;

  void start() {
    if (!isActive) {
      _ticker.start();
    }
    print("VisualFeastLooper started!");
  }

  void stop() {
    _ticker.stop();
    print("VisualFeastLooper stopped!");
  }

  void pause() {
    _ticker.muted = true;
    previous = Duration.zero;
    print("VisualFeastLooper paused!");
  }

  void resume() {
    _ticker.muted = false;
    print("VisualFeastLooper resumed!");
  }
}
