import 'dart:math';

import 'package:flutter_utils/common/range.dart';

/// Created by @RealCradle on 2021/7/15

class BezierCurve {
  final List<double> anchors;

  static const double _errorBound = 0.001;

  BezierCurve(this.anchors);

  double _evaluate(double fraction) {
    double result = 0;
    for (int i = 0; i < anchors.length; ++i) {
      final coefficient = (i == 0 || i == anchors.length - 1) ? 1 : (anchors.length - 1);
      result += anchors[i] * coefficient * pow(1 - fraction, (anchors.length - i) - 1) * pow(fraction, i);
    }
    return result;
  }

  double transform(double t) {
    return _evaluate(t);
  }
}

class KeyFrame {
  final Range stop;
  final Duration duration;

  int _elapsedInMillis = 0;
  double _percent = 0.0;

  int get elapsedInMillis => _elapsedInMillis;

  double get percent => _percent;

  double get relativePercent => _percent * stop.interval.toDouble();

  KeyFrame(this.stop, this.duration);

  double tick(int timeInTick, bool reversed) {
    _elapsedInMillis = min(_elapsedInMillis + timeInTick, duration.inMilliseconds);
    if (duration.inMicroseconds == 0) {
      _percent = 1.0;
    } else {
      if (reversed) {
        _percent = 1 - _elapsedInMillis.toDouble() / duration.inMilliseconds;
      } else {
        _percent = _elapsedInMillis.toDouble() / duration.inMilliseconds;
      }
    }
    return _percent;
  }

  bool isCompleted() => _elapsedInMillis >= duration.inMilliseconds;
}
