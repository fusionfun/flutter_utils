/// Created by @RealCradle on 2021/7/7

part of "design.dart";

class DesignOffset extends DesignObject<Offset> {
  final DesignField dx;
  final DesignField dy;

  Offset? _offset;

  Offset get offset => _offset!;

  DesignOffset(this.dx, this.dy);

  @override
  Offset measure(_DeviceMetrics metrics) {
    if (_offset == null) {
      final _dx = dx.measure(metrics);
      final _dy = dy.measure(metrics);
      _offset = Offset(_dx, _dy);
    }
    return _offset!;
  }
}
