part of 'design.dart';

/// Created by Haoyi on 2021/11/23

abstract class DesignSize extends DesignObject<Size> {
  Size get size;
}

class _DesignFieldSize extends DesignSize {
  final DesignField width;
  final DesignField height;

  Size? _size;

  Size get size => _size!;

  _DesignFieldSize(this.width, this.height);

  @override
  Size measure(_DeviceMetrics metrics) {
    if (_size == null) {
      final _w = width.measure(metrics);
      final _h = height.measure(metrics);
      _size = Size(_w, _h);
    }
    return _size!;
  }
}

class _DesignExplicitSize extends DesignSize {
  final double width;
  final double height;

  Size? _size;

  Size get size => _size!;

  _DesignExplicitSize(this.width, this.height);

  @override
  Size measure(_DeviceMetrics metrics) {
    if (_size == null) {
      final _w = DesignField._calculate(_DesignMethod.width, metrics, width);
      final _h = DesignField._calculate(_DesignMethod.height, metrics, height);
      _size = Size(_w, _h);
    }
    return _size!;
  }
}

class _DesignWidthRatioSize extends DesignSize {
  final double width;
  final double ratio;

  Size? _size;

  Size get size => _size!;

  _DesignWidthRatioSize(this.width, this.ratio);

  @override
  Size measure(_DeviceMetrics metrics) {
    if (_size == null) {
      final _w = DesignField._calculate(_DesignMethod.width, metrics, width);
      final _h = _w * ratio;
      _size = Size(_w, _h);
    }
    return _size!;
  }
}

class _DesignHeightRatioSize extends DesignSize {
  final double height;
  final double ratio;

  Size? _size;

  Size get size => _size!;

  _DesignHeightRatioSize(this.height, this.ratio);

  @override
  Size measure(_DeviceMetrics metrics) {
    if (_size == null) {
      final _h = DesignField._calculate(_DesignMethod.height, metrics, height);
      final _w = _h * ratio;
      _size = Size(_w, _h);
    }
    return _size!;
  }
}
