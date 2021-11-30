/// Created by @RealCradle on 2021/7/7
///

part of "design.dart";

class _DeviceMetrics {
  final double wScale;
  final double hScale;
  final Size size;
  final TextDirection? direction;

  const _DeviceMetrics(this.wScale, this.hScale, this.size, this.direction);
}

enum _DesignMethod { width, height, average, widthScale, heightScale, combine, origin, statusBarHeight, navigationBarHeight }

class DesignMetrics {
  final Size designResolution;
  final List<DesignObject> objects = [];

  static Map<num, DesignField> originFields = {
    0: DesignField._origin(0),
    1: DesignField._origin(1),
    2: DesignField._origin(2),
    3: DesignField._origin(3),
    4: DesignField._origin(4),
    5: DesignField._origin(5),
    6: DesignField._origin(6),
    7: DesignField._origin(7),
    8: DesignField._origin(8),
    9: DesignField._origin(9),
  };

  DesignMetrics.create(this.designResolution);

  DesignField origin(num value) {
    final result = originFields[value];
    if (result != null) {
      return result;
    }
    final field = DesignField._origin(value);
    originFields[value] = field;
    return field;
  }

  DesignField designWidth(double size) {
    final field = DesignField._width(size);
    _add(field);
    return field;
  }

  DesignField designHorizontal(double size) {
    final field = DesignField._width(size);
    _add(field);
    return field;
  }

  DesignField designHeight(double size) {
    final field = DesignField._height(size);
    _add(field);
    return field;
  }

  DesignField designVertical(double size) {
    final field = DesignField._height(size);
    _add(field);
    return field;
  }

  DesignField designFontSize(double size) {
    final field = DesignField._average(size);
    _add(field);
    return field;
  }

  DesignField designAverageSize(double size) {
    final field = DesignField._average(size);
    _add(field);
    return field;
  }

  DesignField design(DesignField field) {
    _add(field);
    return field;
  }

  DesignField widthScale(double scale) {
    final field = DesignField._widthScale(scale);
    _add(field);
    return field;
  }

  DesignField heightScale(double scale) {
    final field = DesignField._heightScale(scale);
    _add(field);
    return field;
  }

  DesignField relativeRatio(DesignField relative, double ratio) {
    final field = DesignField._relativeRatio(relative, ratio);
    _add(field);
    return field;
  }

  DesignSize designSize(double width, double height) {
    final size = _DesignExplicitSize(width, height);
    _add(size);
    return size;
  }

  DesignSize designFieldSize(DesignField width, DesignField height) {
    final size = _DesignFieldSize(width, height);
    _add(size);
    return size;
  }

  DesignSize widthRatioSize({required double width, required double ratio}) {
    final size = _DesignWidthRatioSize(width, ratio);
    _add(size);
    return size;
  }

  DesignSize heightRatioSize({required double height, required double ratio}) {
    final size = _DesignHeightRatioSize(height, ratio);
    _add(size);
    return size;
  }

  DesignRect fromLTRB(double left, double top, double right, double bottom) {
    final rect = _DesignExplicitRect.fromLTRB(left, top, right, bottom);
    _add(rect);
    return rect;
  }

  DesignRect fromLTWH(double left, double top, double width, double height) {
    return fromLTRB(left, top, left + width, top + height);
  }

  DesignRect fromCenter(Offset center, double width, double height) {
    return fromLTRB(center.dx - width * 0.5, center.dy - height * 0.5, center.dx + width * 0.5, center.dy + height * 0.5);
  }

  DesignRect fromFieldLTRB(DesignField left, DesignField top, DesignField right, DesignField bottom) {
    final rect = _DesignFieldRect.fromLTRB(left, top, right, bottom);
    _add(rect);
    return rect;
  }

  DesignRect fromFieldLTWH(DesignField left, DesignField top, DesignField width, DesignField height) {
    return fromFieldLTRB(left, top, left + width, top + height);
  }

  DesignRect fromFieldCenter(DesignField centerX, DesignField centerY, DesignField width, DesignField height) {
    return fromFieldLTRB(centerX - DesignField._relativeRatio(width, 0.5), centerY - DesignField._relativeRatio(height, 0.5),
        centerX + DesignField._relativeRatio(width, 0.5), centerY + DesignField._relativeRatio(height, 0.5));
  }

  DesignOffset offset(DesignField dx, DesignField dy) {
    final offset = DesignOffset(dx, dy);
    _add(offset);
    return offset;
  }

  DesignOffset originOffset(double dx, double dy) {
    return offset(designHorizontal(dx), designVertical(dy));
  }

  void _add(DesignObject object) {
    objects.add(object);
  }

  void measure(Size size) {
    final sizeScale = _DeviceMetrics(size.width / designResolution.width, size.height / designResolution.height, size, null);
    objects.forEach((field) {
      field.measure(sizeScale);
    });
  }
}
