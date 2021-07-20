import 'dart:math';

import 'package:flutter/animation.dart';
import 'keyframe/key_frame.dart';
import '../common/range.dart';

/// Created by @RealCradle on 2021/7/7
///
///

const repeat_infinity = -1;

enum VisualFeastAnimationState { init, paused, waiting, playing, finallyRender, completed }

typedef AnimationStartedCallback = void Function();
typedef AnimationUpdateCallback = void Function(double value, double percent, int _elapsedInMillis);
typedef AnimationCompletedCallback = void Function();
typedef AnimationRepeatCallback = void Function(int repeat);
typedef AnimationNextCallback = void Function(BaseVisualFeastAnimation animation);
typedef AnimationSetUpdateCallback = void Function(double percent, int _elapsedInMillis);

abstract class BaseVisualFeastAnimation {
  VisualFeastAnimationState saveState = VisualFeastAnimationState.init;
  VisualFeastAnimationState state = VisualFeastAnimationState.init;

  List<BaseVisualFeastAnimation> _joinedAnimation = [];

  bool get isCompleted => state == VisualFeastAnimationState.completed;

  bool get isStarted => state == VisualFeastAnimationState.playing || state == VisualFeastAnimationState.finallyRender;

  void wrap({AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat,
    AnimationNextCallback? onNext});

  void start() {
    if (state == VisualFeastAnimationState.init) {
      state = VisualFeastAnimationState.waiting;
    }
  }

  void pause() {
    saveState = state;
    state = VisualFeastAnimationState.paused;
  }

  void resume() {
    state = saveState;
  }

  void stop() {
    state = VisualFeastAnimationState.completed;
  }

  void join(BaseVisualFeastAnimation animation) {
    if (animation != this) {
      animation._joinedAnimation.add(this);
    }
  }

  void _stopJoinedAnimations() {
    _joinedAnimation.forEach((animation) {
      animation.stop();
    });
  }

  void update(double t);
}

mixin SingleVisualFeastAnimation on BaseVisualFeastAnimation {
  AnimationStartedCallback? onStarted;
  AnimationUpdateCallback? onUpdate;
  AnimationCompletedCallback? onCompleted;
  AnimationRepeatCallback? onRepeat;
}

mixin MultiVisualFeastAnimation on BaseVisualFeastAnimation {}

class VisualFeastAnimation extends BaseVisualFeastAnimation with SingleVisualFeastAnimation {
  final Duration delayed;
  final Duration duration;
  Curve curve;
  int _elapsedInMillis = 0;
  int repeat = 0;
  int _repeatCount = 0;
  bool reverse = false;
  final double from;
  final double to;
  final dynamic extra;


  VisualFeastAnimation({this.from = 0.0,
    this.to = 1.0,
    required this.duration,
    this.repeat = 0,
    this.curve = Curves.linear,
    this.reverse = false,
    this.delayed = const Duration(seconds: 0),
    this.extra,
    AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat}) {
    this.onStarted = onStarted;
    this.onUpdate = onUpdate;
    this.onCompleted = onCompleted;
    this.onRepeat = onRepeat;
  }

  void wrap({AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat,
    AnimationNextCallback? onNext}) {
    this.onStarted = onStarted ?? this.onStarted;
    this.onUpdate = onUpdate ?? this.onUpdate;
    this.onCompleted = onCompleted ?? this.onCompleted;
    this.onRepeat = onRepeat ?? this.onRepeat;
  }

  void directComplete() {
    if (state != VisualFeastAnimationState.completed) {
      if (state != VisualFeastAnimationState.playing) {
        onStarted?.call();
      }
      onUpdate?.call(to, 1.0, _elapsedInMillis);
      state = VisualFeastAnimationState.completed;
      onCompleted?.call();
      _stopJoinedAnimations();
    }
  }

  void update(double t) {
    if (state == VisualFeastAnimationState.completed || state == VisualFeastAnimationState.paused || state == VisualFeastAnimationState.init) {
      return;
    } else if (state == VisualFeastAnimationState.finallyRender) {
      if (repeat < 0 || _repeatCount < repeat) {
        _repeatCount++;
        _elapsedInMillis = 0;
        state = VisualFeastAnimationState.playing;
        onRepeat?.call(_repeatCount);
      } else {
        onUpdate?.call(to, 1.0, duration.inMilliseconds);
        onCompleted?.call();
        state = VisualFeastAnimationState.completed;
        _stopJoinedAnimations();
      }
      return;
    }

    int timeInTick = (t * 1000).toInt();
    if (state == VisualFeastAnimationState.waiting) {
      if (delayed.inMilliseconds > 0) {
        _elapsedInMillis += timeInTick;
      }
      timeInTick = _elapsedInMillis - delayed.inMilliseconds;
      if (timeInTick < 0) {
        return;
      }
      _elapsedInMillis = 0;
      state = VisualFeastAnimationState.playing;
      onStarted?.call();
    }

    _elapsedInMillis = min(_elapsedInMillis + timeInTick, duration.inMilliseconds);
    double percent;
    if (duration.inMicroseconds == 0) {
      percent = 1.0;
    } else {
      if (reverse && (_repeatCount & 0x01 == 1)) {
        percent = 1 - _elapsedInMillis.toDouble() / duration.inMilliseconds;
      } else {
        percent = _elapsedInMillis.toDouble() / duration.inMilliseconds;
      }
    }
    final value = curve.transform(percent);
    onUpdate?.call(from + (value * (to - from)), percent, _elapsedInMillis);
    if (_elapsedInMillis >= duration.inMilliseconds) {
      state = VisualFeastAnimationState.finallyRender;
    }
  }
}

class VisualFeastKeyFrameAnimation extends BaseVisualFeastAnimation with SingleVisualFeastAnimation {
  final Duration delayed;

  final List<KeyFrame> keyFrames;
  int _latestCompletedElapsedInMillis = 0;
  double _latestCompletedPercent = 0;
  final Curve curve;
  int repeat = 0;
  int _repeatCount = 0;
  bool reverse = false;
  final double from;
  final double to;
  final dynamic extra;

  int _keyFrameIndex = 0;

  final Duration duration;

  void wrap({AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat,
    AnimationNextCallback? onNext}) {
    this.onStarted = onStarted ?? this.onStarted;
    this.onUpdate = onUpdate ?? this.onUpdate;
    this.onCompleted = onCompleted ?? this.onCompleted;
    this.onRepeat = onRepeat ?? this.onRepeat;
  }

  KeyFrame? getCurrentKeyFrame() {
    if (_keyFrameIndex < keyFrames.length) {
      return keyFrames[_keyFrameIndex];
    }
    return null;
  }

  void moveNextKeyFrame() {
    // TODO: 这里还没有使用reversed时的状态
    _keyFrameIndex = _keyFrameIndex + 1;
  }

  VisualFeastKeyFrameAnimation({this.from = 0.0,
    this.to = 1.0,
    required List<double> stops,
    required List<Duration> durations,
    this.curve = Curves.linear,
    this.repeat = 0,
    this.reverse = false,
    this.delayed = const Duration(seconds: 0),
    this.extra,
    AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat})
      : assert(durations.length == stops.length),
        keyFrames = List.generate(stops.length, (index) => KeyFrame(Range(index > 0 ? stops[index - 1] : 0, stops[index]), durations[index]),
            growable: false),
        duration = durations.reduce((value, element) => value + element) {
    this.onStarted = onStarted;
    this.onUpdate = onUpdate;
    this.onCompleted = onCompleted;
    this.onRepeat = onRepeat;
  }

  void directComplete() {
    if (state != VisualFeastAnimationState.completed) {
      if (state != VisualFeastAnimationState.playing) {
        onStarted?.call();
      }
      onUpdate?.call(to, 1.0, duration.inMilliseconds);
      state = VisualFeastAnimationState.completed;
      onCompleted?.call();
      _stopJoinedAnimations();
    }
  }

  void update(double t) {
    if (state == VisualFeastAnimationState.completed || state == VisualFeastAnimationState.paused || state == VisualFeastAnimationState.init) {
      return;
    } else if (state == VisualFeastAnimationState.finallyRender) {
      if (repeat < 0 || _repeatCount < repeat) {
        _repeatCount++;
        _latestCompletedElapsedInMillis = 0;
        state = VisualFeastAnimationState.playing;
        onRepeat?.call(_repeatCount);
      } else {
        onUpdate?.call(to, 1.0, duration.inMilliseconds);
        onCompleted?.call();
        state = VisualFeastAnimationState.completed;
        _stopJoinedAnimations();
      }
      return;
    }

    int timeInTick = (t * 1000).toInt();
    if (state == VisualFeastAnimationState.waiting) {
      if (delayed.inMilliseconds > 0) {
        _latestCompletedElapsedInMillis += timeInTick;
      }
      timeInTick = _latestCompletedElapsedInMillis - delayed.inMilliseconds;
      if (timeInTick < 0) {
        return;
      }
      _latestCompletedElapsedInMillis = 0;
      state = VisualFeastAnimationState.playing;
      onStarted?.call();
    }
    final reversed = reverse && (_repeatCount & 0x01 == 1);
    final keyFrame = getCurrentKeyFrame();
    if (keyFrame != null) {
      keyFrame.tick(timeInTick, reversed);
      final value = curve.transform(_latestCompletedPercent + keyFrame.relativePercent);
      double percent = _latestCompletedPercent + keyFrame.relativePercent;
      int elapsedInMillis = _latestCompletedElapsedInMillis + keyFrame.elapsedInMillis;
      if (keyFrame.isCompleted()) {
        _latestCompletedElapsedInMillis += keyFrame.duration.inMilliseconds;
        _latestCompletedPercent += keyFrame.stop.interval.toDouble();
        percent = _latestCompletedPercent;
        elapsedInMillis = _latestCompletedElapsedInMillis;
        moveNextKeyFrame();
      }
      onUpdate?.call(from + (value * (to - from)), percent, elapsedInMillis);
    } else {
      state = VisualFeastAnimationState.finallyRender;
    }
  }
}

class VisualFeastAnimationSet extends BaseVisualFeastAnimation with MultiVisualFeastAnimation {
  final List<BaseVisualFeastAnimation> animations;
  final bool sequentially;

  int current = 0;

  AnimationStartedCallback? onStarted;
  AnimationCompletedCallback? onCompleted;
  AnimationNextCallback? onNext;

  VisualFeastAnimationSet(this.animations, {this.sequentially = false, this.onStarted, this.onCompleted, this.onNext});

  VisualFeastAnimationSet.sequentially(this.animations, {this.onStarted, this.onCompleted, this.onNext}) : sequentially = true;

  VisualFeastAnimationSet.together(this.animations, {this.onStarted, this.onCompleted, this.onNext}) : sequentially = false;

  void wrap({AnimationStartedCallback? onStarted,
    AnimationUpdateCallback? onUpdate,
    AnimationCompletedCallback? onCompleted,
    AnimationRepeatCallback? onRepeat,
    AnimationNextCallback? onNext}) {
    this.onStarted = onStarted ?? this.onStarted;
    this.onCompleted = onCompleted ?? this.onCompleted;
    this.onNext = onNext ?? this.onNext;
  }

  @override
  void start() {
    if (sequentially) {
      animations[current].start();
    } else {
      animations.forEach((animation) {
        animation.start();
      });
    }
    super.start();
  }

  void update(double t) {
    if (state == VisualFeastAnimationState.completed || state == VisualFeastAnimationState.paused || state == VisualFeastAnimationState.init) {
      return;
    }
    if (sequentially) {
      if (current >= animations.length) {
        return;
      }
      final animation = animations[current];
      animation.update(t);
      switch (animation.state) {
        case VisualFeastAnimationState.completed:
          current++;
          if (current < animations.length) {
            animations[current].start();
          } else {
            onCompleted?.call();
            state = VisualFeastAnimationState.completed;
            _stopJoinedAnimations();
          }
          break;
        case VisualFeastAnimationState.playing:
          if (current == 0) {
            onStarted?.call();
            state = VisualFeastAnimationState.playing;
          } else {
            onNext?.call(animation);
          }
          break;
        default:
          break;
      }
    } else {
      bool completed = true;
      animations.forEach((animation) {
        animation.update(t);
        if (current == 0 && animation.isStarted) {
          onStarted?.call();
          state = VisualFeastAnimationState.playing;
          current++;
        }
        completed &= animation.isCompleted;
      });

      if (completed) {
        onCompleted?.call();
        state = VisualFeastAnimationState.completed;
        _stopJoinedAnimations();
      }
    }
  }
}