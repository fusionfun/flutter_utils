/// Created by @RealCradle on 2021/7/7

part of "design.dart";

class DesignRect extends DesignObject<Rect> {
  final DesignField left;
  final DesignField top;
  final DesignField right;
  final DesignField bottom;

  Rect? _rect;

  Rect get rect => _rect!;

  DesignRect.fromLTRB(this.left, this.top, this.right, this.bottom);

  double get width => rect.width;

  double get height => rect.height;

  Offset get topLeft => rect.topLeft;

  @override
  Rect measure(_DeviceMetrics metrics) {
    if (_rect == null) {
      final l = left.measure(metrics);
      final t = top.measure(metrics);
      final r = right.measure(metrics);
      final b = bottom.measure(metrics);
      _rect = Rect.fromLTRB(l, t, r, b);
    }
    return _rect!;
  }
}
