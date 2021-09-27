import 'package:flutter_utils/hash/hash.dart';

import '../datetime_utils.dart';

/// Created by @RealCradle on 2021/8/5

class Date {
  int get year => _datetime.year;

  int get month => _datetime.month;

  int get day => _datetime.day;

  int get weekday => _datetime.weekday;

  String get yyyyMMdd => DateTimeUtils.yyyyMMddDateFormat.format(_datetime);

  String get yyyyMM => "${_datetime.year}${DateTimeUtils.twoDigits(_datetime.month)}";

  int get millisecondsSinceEpoch => _datetime.millisecondsSinceEpoch;

  final DateTime _datetime;

  Date._(DateTime dateTime) : _datetime = DateTime(dateTime.year, dateTime.month, dateTime.day);

  Date.fromDateTime(DateTime dateTime) : _datetime = DateTime(dateTime.year, dateTime.month, dateTime.day);

  Date(int year, [int month = 1, int day = 1]) : _datetime = DateTime(year, month, day);

  static Date fromMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return Date._(dateTime);
  }

  DateTime toDateTime() => _datetime;

  static Date today() {
    return Date._(DateTime.now());
  }

  bool isAfter(Date date) {
    return _datetime.isAfter(date._datetime);
  }

  bool isBefore(Date date) {
    return _datetime.isBefore(date._datetime);
  }

  Date add({int years = 0, int months = 0, int days = 0}) {
    return Date._(DateTime(_datetime.year + years, _datetime.month + months, _datetime.day + days));
  }

  Date subtract({int years = 0, int months = 0, int days = 0}) {
    return Date._(DateTime(_datetime.year - years, _datetime.month - months, _datetime.day - days));
  }

  Date clamp(Date lowerLimit, Date upperLimit) {
    DateTime dt = _datetime;

    if (dt.isBefore(lowerLimit._datetime)) {
      dt = lowerLimit._datetime;
    }
    if (dt.isAfter(upperLimit._datetime)) {
      dt = upperLimit._datetime;
    }
    return Date._(dt);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Date && runtimeType == other.runtimeType && _datetime == other._datetime;

  @override
  int get hashCode => hash3(year, month, day);

  int differenceDays(Date date) {
    return _datetime
        .difference(date._datetime)
        .inDays;
  }
}
