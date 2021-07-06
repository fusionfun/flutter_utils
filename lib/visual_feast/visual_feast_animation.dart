import 'dart:math';

import 'package:flutter/animation.dart';

/// Created by @RealCradle on 2021/7/7
///
///

const repeat_infinity = -1;

enum VisualFeastAnimationState {
  init,
  paused,
  waiting,
  playing,
  finallyRender,
  completed
}

typedef AnimationStartedCallback = void Function();
typedef AnimationUpdateCallback = void Function(
    double value, double percent, int elapseInMillis);
typedef AnimationCompletedCallback = void Function();
typedef AnimationRepeatCallback = void Function(int repeat);
typedef AnimationNextCallback = void Function(BaseVisualFeastAnimation animation);

abstract class BaseVisualFeastAnimation {
  VisualFeastAnimationState saveState = VisualFeastAnimationState.init;
  VisualFeastAnimationState state = VisualFeastAnimationState.init;

  List<BaseVisualFeastAnimation> _joinedAnimation = [];

  bool get isCompleted => state == VisualFeastAnimationState.completed;

  bool get isStarted =>
      state == VisualFeastAnimationState.playing ||
      state == VisualFeastAnimationState.finallyRender;

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

class VisualFeastAnimation extends BaseVisualFeastAnimation {
  final Duration delayed;
  final Duration duration;
  Curve curve;
  int _elapseInMillis = 0;
  int repeat = 0;
  int _repeatCount = 0;
  bool reverse = false;
  final double from;
  final double to;
  final dynamic extra;
  AnimationStartedCallback? onStarted;
  AnimationUpdateCallback? onUpdate;
  AnimationCompletedCallback? onCompleted;
  AnimationRepeatCallback? onRepeat;

  VisualFeastAnimation(
      {this.from = 0.0,
      this.to = 1.0,
      required this.duration,
      this.repeat = 0,
      this.curve = Curves.linear,
      this.reverse = false,
      this.delayed = const Duration(seconds: 0),
      this.extra,
      this.onStarted,
      this.onUpdate,
      this.onCompleted,
      this.onRepeat});

  void directComplete() {
    if (state != VisualFeastAnimationState.completed) {
      if (state != VisualFeastAnimationState.playing) {
        onStarted?.call();
      }
      onUpdate?.call(to, 1.0, _elapseInMillis);
      state = VisualFeastAnimationState.completed;
      onCompleted?.call();
      _stopJoinedAnimations();
    }
  }

  void update(double t) {
    if (state == VisualFeastAnimationState.completed ||
        state == VisualFeastAnimationState.paused ||
        state == VisualFeastAnimationState.init) {
      return;
    } else if (state == VisualFeastAnimationState.finallyRender) {
      if (repeat < 0 || _repeatCount < repeat) {
        _repeatCount++;
        _elapseInMillis = 0;
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
        _elapseInMillis += timeInTick;
      }
      timeInTick = _elapseInMillis - delayed.inMilliseconds;
      if (timeInTick < 0) {
        return;
      }
      _elapseInMillis = 0;
      state = VisualFeastAnimationState.playing;
      onStarted?.call();
    }

    _elapseInMillis =
        min(_elapseInMillis + timeInTick, duration.inMilliseconds);
    double percent;
    if (duration.inMicroseconds == 0) {
      percent = 1.0;
    } else {
      if (reverse && (_repeatCount & 0x01 == 1)) {
        percent = 1 - _elapseInMillis.toDouble() / duration.inMilliseconds;
      } else {
        percent = _elapseInMillis.toDouble() / duration.inMilliseconds;
      }
    }
    final value = curve.transform(percent);
    onUpdate?.call(from + (value * (to - from)), percent, _elapseInMillis);
    if (_elapseInMillis >= duration.inMilliseconds) {
      state = VisualFeastAnimationState.finallyRender;
    }
  }
}

class VisualFeastAnimationSet extends BaseVisualFeastAnimation {
  final List<BaseVisualFeastAnimation> animations;
  final bool sequentially;

  int current = 0;

  final AnimationStartedCallback? onStarted;
  final AnimationCompletedCallback? onCompleted;
  final AnimationNextCallback? onNext;

  VisualFeastAnimationSet(this.animations,
      {this.sequentially = false,
      this.onStarted,
      this.onCompleted,
      this.onNext});

  VisualFeastAnimationSet.sequentially(this.animations,
      {this.onStarted, this.onCompleted, this.onNext})
      : sequentially = true;

  VisualFeastAnimationSet.together(this.animations,
      {this.onStarted, this.onCompleted, this.onNext})
      : sequentially = false;

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
    if (state == VisualFeastAnimationState.completed ||
        state == VisualFeastAnimationState.paused ||
        state == VisualFeastAnimationState.init) {
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
