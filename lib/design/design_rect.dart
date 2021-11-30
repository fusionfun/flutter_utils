/// Created by @RealCradle on 2021/7/7

part of "design.dart";

abstract class DesignRect extends DesignObject<Rect> {
  Rect get rect;

  double get width;

  double get height;

  Offset get topLeft;

  Offset get bottomLeft;

  Offset get topRight;

  Offset get bottomRight;

  Offset get center;

  DesignField get topField;

  DesignField get leftField;

  DesignField get rightField;

  DesignField get bottomField;
}

class _DesignFieldRect extends DesignRect {
  final DesignField leftField;
  final DesignField topField;
  final DesignField rightField;
  final DesignField bottomField;

  Rect? _rect;

  Rect get rect => _rect!;

  _DesignFieldRect.fromLTRB(this.leftField, this.topField, this.rightField, this.bottomField);

  double get width => rect.width;

  double get height => rect.height;

  Offset get topLeft => rect.topLeft;

  Offset get bottomLeft => rect.bottomLeft;

  Offset get topRight => rect.topRight;

  Offset get bottomRight => rect.bottomRight;

  Offset get center => rect.center;

  @override
  Rect measure(_DeviceMetrics metrics) {
    if (_rect == null) {
      final l = leftField.measure(metrics);
      final t = topField.measure(metrics);
      final r = rightField.measure(metrics);
      final b = bottomField.measure(metrics);
      _rect = Rect.fromLTRB(l, t, r, b);
    }
    return _rect!;
  }
}

class _DesignExplicitRect extends DesignRect {
  final double left;
  final double top;
  final double right;
  final double bottom;

  Rect? _rect;

  Rect get rect => _rect!;

  _DesignExplicitRect.fromLTRB(this.left, this.top, this.right, this.bottom);

  double get width => rect.width;

  double get height => rect.height;

  Offset get topLeft => rect.topLeft;

  Offset get bottomLeft => rect.bottomLeft;

  Offset get topRight => rect.topRight;

  Offset get bottomRight => rect.bottomRight;

  Offset get center => rect.center;

  @override
  DesignField get bottomField => DesignField._height(bottom);

  @override
  DesignField get leftField => DesignField._width(left);

  @override
  DesignField get rightField => DesignField._width(right);

  @override
  DesignField get topField => DesignField._height(top);

  @override
  Rect measure(_DeviceMetrics metrics) {
    if (_rect == null) {
      final l = DesignField._calculate(_DesignMethod.width, metrics, left);
      final t = DesignField._calculate(_DesignMethod.height, metrics, top);
      final r = DesignField._calculate(_DesignMethod.width, metrics, right);
      final b = DesignField._calculate(_DesignMethod.height, metrics, bottom);
      _rect = Rect.fromLTRB(l, t, r, b);
    }
    return _rect!;
  }
}
