import 'package:flutter_utils/datetime/datetime_utils.dart';

/// Created by @RealCradle on 2021/7/20
///

enum RangeType {
  INCLUSIVE_INCLUSIVE, // [begin, end]
  INCLUSIVE_EXCLUSIVE, // [begin, end)
  EXCLUSIVE_INCLUSIVE, // (begin, end]
  EXCLUSIVE_EXCLUSIVE // (begin, end)
}

class Range {
  final num begin;
  final num end;

  const Range(this.begin, this.end);

  Range.sinceNow(Duration duration)
      : this.begin = DateTimeUtils.currentTimeInSecond(),
        this.end = DateTimeUtils.currentTimeInSecond() + duration.inSeconds;

  static Range? fromString(String text) {
    if (text?.isNotEmpty != true) {
      return null;
    }
    final values = text.split(":");
    try {
      if (values.length >= 2) {
        return Range(int.parse(values[0]), int.parse(values[1]));
      }
    } catch (error) {}
    return null;
  }

  bool inRange(num value, {RangeType type = RangeType.INCLUSIVE_INCLUSIVE}) {
    switch (type) {
      case RangeType.INCLUSIVE_INCLUSIVE:
        return value >= begin && value <= end;
      case RangeType.INCLUSIVE_EXCLUSIVE:
        return value >= begin && value < end;
      case RangeType.EXCLUSIVE_INCLUSIVE:
        return value > begin && value <= end;
      default:
        return value > begin && value < end;
    }
  }

  @override
  String toString() {
    if (begin != null && end != null) {
      return "$begin:$end";
    }
    return "";
  }

  num get interval => end - begin;
}
