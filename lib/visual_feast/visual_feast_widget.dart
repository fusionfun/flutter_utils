
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_utils/visual_feast/visual_feast_animation.dart';
import 'package:flutter_utils/visual_feast/visual_feast_looper.dart';

part 'visual_feast_render.dart';

/// Created by @RealCradle on 2021/7/7

mixin Director {
  VoidCallback? _startCallback;
  VoidCallback? _stopCallback;
  VoidCallback? _pauseCallback;
  VoidCallback? _resumeCallback;

  void onResize(Size size) {}

  void onUpdate(double t) {}

  void onRender(Canvas canvas) {}
}

class _VisualFeastRenderBox extends RenderBox with WidgetsBindingObserver {
  final BuildContext context;
  late VisualFeastLooper looper;
  Director director;
  final bool autoStart;

  _VisualFeastRenderBox(this.context, this.director, {this.autoStart = false}) {
    looper = VisualFeastLooper(_looperCallback);
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();
    director?.onResize(constraints.biggest);
  }

  void start() {
    looper.start();
  }

  void pause() {
    looper.pause();
  }

  void resume() {
    looper.resume();
  }

  void stop() {
    looper.stop();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (autoStart) {
      start();
    }
    director._startCallback = start;
    director._resumeCallback = resume;
    director._pauseCallback = pause;
    director._stopCallback = stop;

    print("####### attach");
    _bindLifecycleListener();
  }

  @override
  void detach() {
    _unbindLifecycleListener();
    stop();
    super.detach();
  }

  void _looperCallback(double dt) {
    if (!attached) {
      return;
    }
    print("_looperCallback $dt");
    director?.onUpdate(dt);
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    director?.onRender(context.canvas);
    context.canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
}

// class OldVisualFeastRenderWidget extends LeafRenderObjectWidget with Director {
//   final Size size;
//
//   OldVisualFeastRenderWidget({this.size});
//
//   List<BaseVisualFeastAnimation> animations = [];
//
//   @override
//   RenderBox createRenderObject(BuildContext context) {
//     return RenderConstrainedBox(
//         child: _VisualFeastRenderBox(context, this),
//         additionalConstraints: BoxConstraints.expand(width: size?.width, height: size?.height));
//   }
//
//   @override
//   void updateRenderObject(BuildContext context, RenderConstrainedBox renderBox) {
//     renderBox
//       ..child = _VisualFeastRenderBox(context, this)
//       ..additionalConstraints = BoxConstraints.expand(width: size?.width, height: size?.height);
//   }
//
//   void _performAnimation(BaseVisualFeastAnimation animation) {
//     if (animations.isEmpty) {
//       _startCallback?.call();
//       _resumeCallback?.call();
//     }
//     animations.add(animation..start());
//     print("_performAnimation ${animations.length}");
//   }
//
//   VisualFeastAnimationSet playSequentially(List<VisualFeastAnimation> animations,
//       {AnimationStartedCallback onStarted,
//       AnimationCompletedCallback onCompleted,
//       AnimationNextCallback onNext}) {
//     final animationSet = VisualFeastAnimationSet(animations,
//         sequentially: true, onStarted: onStarted, onNext: onNext, onCompleted: onCompleted)
//       ..start();
//     _performAnimation(animationSet);
//     return animationSet;
//   }
//
//   VisualFeastAnimationSet playTogether(List<VisualFeastAnimation> animations,
//       {AnimationStartedCallback onStarted, AnimationCompletedCallback onCompleted}) {
//     final animationSet = VisualFeastAnimationSet(animations,
//         sequentially: false, onStarted: onStarted, onCompleted: onCompleted)
//       ..start();
//     _performAnimation(animationSet);
//     return animationSet;
//   }
//
//   void play(VisualFeastAnimation animation) {
//     _performAnimation(animation);
//   }
//
//   @override
//   void onRender(Canvas canvas) {
//     super.onRender(canvas);
//   }
//
//   int count = 0;
//
//   @override
//   void onUpdate(double t) {
//     super.onUpdate(t);
//     List<BaseVisualFeastAnimation> updateAnimations = List.from(animations);
//     animations.clear();
//     for (BaseVisualFeastAnimation animation in updateAnimations) {
//       if (!animation.isCompleted) {
//         animation.update(t);
//         animations.add(animation);
//       } else {}
//     }
//     if (animations.isEmpty) {
//       _pauseCallback?.call();
//     }
//   }
//
//   @override
//   void onResize(Size size) {
//     super.onResize(size);
//   }
// }

// class _VisualFeast extends LeafRenderObjectWidget with Director {
//   final Size size;
//
//   final List<VisualFeastRender> renderList = [];
//   final List<VisualFeastRender> tempRenderList = [];
//
//   _VisualFeast({this.size});
//
//   void scheduleRenders(List<VisualFeastRender> renders) {
//     final isEmpty = renderList.isEmpty;
//     renderList.forEach((render) {
//       render.stopRender();
//     });
//     renderList.clear();
//     renders?.forEach((render) {
//       renderList.add(render);
//       render.startRender();
//     });
//     if (isEmpty && renderList.length > 0) {
//       _startCallback?.call();
//       _resumeCallback?.call();
//     } else if (!isEmpty && renderList.isEmpty) {
//       _pauseCallback?.call();
//     }
//   }
//
//   void dispose() {
//     print("dispose");
//     _stopCallback?.call();
//     scheduleRenders(null);
//   }
//
//   @override
//   RenderBox createRenderObject(BuildContext context) {
//     return RenderConstrainedBox(
//         child: _VisualFeastRenderBox(context, this),
//         additionalConstraints: BoxConstraints.expand(width: size?.width, height: size?.height));
//   }
//
//   @override
//   void updateRenderObject(BuildContext context, RenderConstrainedBox renderBox) {
//     renderBox
//       ..child = _VisualFeastRenderBox(context, this)
//       ..additionalConstraints = BoxConstraints.expand(width: size?.width, height: size?.height);
//   }
//
//   @override
//   void onRender(Canvas canvas) {
//     super.onRender(canvas);
//     renderList.forEach((render) {
//       if (render.shouldRender()) {
//         render._dispatchRender(canvas);
//       }
//     });
//   }
//
//   @override
//   void onUpdate(double t) {
//     super.onUpdate(t);
//     tempRenderList.clear();
//     tempRenderList.addAll(renderList);
//     renderList.clear();
//     tempRenderList.forEach((render) {
//       if (!render.renderCompleted()) {
//         render._dispatchUpdate(t);
//         print("render:${render.isAnimationCompleted} ${render.clearAfterCompleted}");
//         if (!render.isAnimationCompleted || !render.clearAfterCompleted) {
//           renderList.add(render);
//         }
//       }
//     });
//
//
//     if (renderList.isEmpty) {
//       _pauseCallback?.call();
//     }
//   }
//
//   @override
//   void onResize(Size size) {
//     super.onResize(size);
//   }
// }

// class VisualFeastWidget extends StatefulWidget {
//   VisualFeastWidget({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => VisualFeastState();
// }
//
// class VisualFeastState extends State<VisualFeastWidget> {
//   _VisualFeast _visualFeast;
//
//   void scheduleRenders(List<VisualFeastRender> renders) {
//     print("scheduleRenders :${renders.length}");
//     _visualFeast.scheduleRenders(renders);
//   }
//
//   void stopAll(Key key) {
//     _visualFeast.scheduleRenders(null);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _visualFeast = _VisualFeast();
//   }
//
//   @override
//   void dispose() {
//     _visualFeast.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _visualFeast;
//   }
// }
