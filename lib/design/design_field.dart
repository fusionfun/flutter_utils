/// Created by @RealCradle on 2021/7/7
///

part of "design.dart";

abstract class CombinedValue {
  double combine(_DeviceMetrics metrics);
}

class SimpleCombinedValue extends CombinedValue {
  final DesignField field1;
  final DesignField field2;
  final double Function(double a, double b) combiner;

  SimpleCombinedValue(this.field1, this.field2, this.combiner);

  double combine(_DeviceMetrics metrics) {
    final a = field1.measure(metrics);
    final b = field2.measure(metrics);
    return combiner.call(a, b);
  }
}

class RatioCombinedValue extends CombinedValue {
  final DesignField relative;
  final double scale;

  RatioCombinedValue(this.relative, this.scale);

  double combine(_DeviceMetrics metrics) {
    final value = relative.measure(metrics);
    return value * scale;
  }
}

abstract class DesignObject<T> {
  T measure(_DeviceMetrics metrics);
}

class DesignField extends DesignObject<double> {
  final _DesignMethod designMethod;
  final dynamic designValue;

  double? _size;

  static double _calculate(_DesignMethod method, _DeviceMetrics metrics, dynamic value) {
    switch (method) {
      case _DesignMethod.origin:
        return value;
      case _DesignMethod.width:
        return value * metrics.wScale;
      case _DesignMethod.height:
        return value * metrics.hScale;
      case _DesignMethod.widthScale:
        return value * metrics.size.width;
      case _DesignMethod.heightScale:
        return value * metrics.size.height;
      case _DesignMethod.combine:
        final combinedValue = value as CombinedValue;
        return combinedValue.combine(metrics);
      case _DesignMethod.statusBarHeight:
        return 0;
      case _DesignMethod.average:
      default:
        return ((value * metrics.hScale) + (value * metrics.wScale)) / 2;
    }
  }

  double measure(_DeviceMetrics metrics) {
    if (_size == null) {
      _size = _calculate(designMethod, metrics, designValue);
    }
    return _size!;
  }

  DesignField._origin(num designValue)
      : this.designValue = designValue,
        this.designMethod = _DesignMethod.origin,
        this._size = designValue.toDouble();

  DesignField._width(double designValue)
      : this.designValue = designValue,
        this.designMethod = _DesignMethod.width;

  DesignField._height(double designValue)
      : this.designValue = designValue,
        designMethod = _DesignMethod.height;

  DesignField._widthScale(double designValue)
      : this.designValue = designValue,
        designMethod = _DesignMethod.widthScale;

  DesignField._heightScale(double designValue)
      : this.designValue = designValue,
        designMethod = _DesignMethod.heightScale;

  DesignField._average(double designValue)
      : this.designValue = designValue,
        designMethod = _DesignMethod.average;

  DesignField._relativeRatio(DesignField relative, double ratio)
      : this.designValue = RatioCombinedValue(relative, ratio),
        designMethod = _DesignMethod.combine;

  DesignField.statusBarHeight()
      : this.designValue = -1,
        designMethod = _DesignMethod.statusBarHeight;

  DesignField.navigationBarHeight()
      : this.designValue = -1,
        designMethod = _DesignMethod.navigationBarHeight;

  DesignField._combine(this.designValue) : this.designMethod = _DesignMethod.combine;

  DesignField operator +(DesignField other) {
    return DesignField._combine(SimpleCombinedValue(this, other, (a, b) => a + b));
  }

  DesignField operator -(DesignField other) {
    return DesignField._combine(SimpleCombinedValue(this, other, (a, b) => a - b));
  }

  DesignField operator *(DesignField other) {
    return DesignField._combine(SimpleCombinedValue(this, other, (a, b) => a * b));
  }

  DesignField operator /(DesignField other) {
    return DesignField._combine(SimpleCombinedValue(this, other, (a, b) => a / b));
  }

  double get size => _size!;
}
