part of 'visual_feast_widget.dart';

/// Created by @RealCradle on 2021/7/7
///

enum RenderState { rendering, paused, completed }

abstract class VisualFeastRender {
  VisualFeastRender();

  RenderState state = RenderState.paused;

  BaseVisualFeastAnimation get animation;

  bool get isAnimationCompleted => animation.isCompleted;

  bool get isAnimationStarted => animation.isStarted;

  bool get clearAfterCompleted => false;

  bool shouldRender() {
    return isAnimationStarted;
  }

  bool renderCompleted() => state == RenderState.completed;

  void startRender() {
    state = RenderState.rendering;
    animation?.start();
  }

  void pauseRender() {
    state = RenderState.paused;
  }

  void stopRender() {
    state = RenderState.completed;
  }

  void _dispatchUpdate(double t) {
    print("update:$t");
    onUpdate(t);
  }

  void _dispatchRender(Canvas canvas) {
    onRender(canvas);
  }

  void onUpdate(double t) {
    animation?.update(t);
  }

  void onRender(Canvas canvas) {}
}

//class VisualFeastRenderSet extends VisualFeastRender {
//  List<VisualFeastRender> renders;
//  final bool sequentially;
//  int current = 0;
//
//  bool get isCompleted {
//    if (sequentially) {
//      return current == renders.length;
//    } else {
//      for (var render in renders) {
//        if (!render.isCompleted) {
//          return false;
//        }
//      }
//      return true;
//    }
//  }
//
//  bool get isStarted => (current > 0 || renders[current].isStarted);
//
//  VisualFeastRenderSet.sequentially(this.renders) : sequentially = true;
//
//  VisualFeastRenderSet.together(this.renders) : sequentially = false;
//
//  @override
//  BaseVisualFeastAnimation get animation => throw UnimplementedError();
//
//  void startRender() {
//    if (sequentially) {
//      renders[current].startRender();
//    } else {
//      renders.forEach((render) {
//        render.startRender();
//      });
//    }
//  }
//
//  void stopRender() {
//    isRender = false;
//    renders.forEach((render) {
//      render.stopRender();
//    });
//  }
//
//  void update(double t) {
//    if (sequentially) {
//      renders[current].update(t);
//      if (renders[current].isCompleted == true) {
//        current++;
//      }
//      if (current < renders.length) {
//        renders[current].startRender();
//        renders[current].update(t);
//      }
//    } else {
//      renders.forEach((render) {
//        render.update(t);
//      });
//    }
//  }
//
//  bool onRender(Canvas canvas) {
//    if (sequentially) {
//      if (current < renders.length) {
//        renders[current]?.onRender(canvas);
////        if (current > 0 && !renders[current].isStarted) {
////          renders[current - 1].onRender(canvas);
////        }
//      }
//    } else {
//      renders.forEach((render) {
//        render.onRender(canvas);
//      });
//    }
//  }
//}

class SimpleVisualFeastRender extends VisualFeastRender {
  final BaseVisualFeastAnimation animation;
  final void Function(Canvas canvas) renderCallback;

  SimpleVisualFeastRender({required this.animation, required this.renderCallback});

  @override
  void onRender(Canvas canvas) {
    renderCallback.call(canvas);
  }
}
