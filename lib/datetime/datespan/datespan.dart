import 'package:flutter_utils/datetime/date/date.dart';

/// Created by @RealCradle on 2021/8/2
///

enum PeriodUnit { NONE, DAILY, WEEKLY, MONTHLY, QUARTERLY, YEARLY }

// [start, end]
class DateSpan {
  final Date start;
  final Date end;

  DateSpan(this.start, this.end);

  int get differenceDays => end.differenceDays(start);

  DateSpan.empty()
      : start = Date(0),
        end = Date(0);

  static DateSpan latest7Days() {
    final today = Date.today();
    return DateSpan(today.subtract(days: 7), today);
  }

  static DateSpan latest14Days() {
    final today = Date.today();
    return DateSpan(today.subtract(days: 14), today);
  }

  static DateSpan latest30Days() {
    final today = Date.today();
    return DateSpan(today.subtract(days: 30), today);
  }
}

class DatePeriod extends Iterable<DateSpan> {
  final DateSpan span;

  final PeriodUnit unit;

  const DatePeriod.create(this.span, this.unit);

  @override
  Iterator<DateSpan> get iterator => throw UnimplementedError();
}

class DailyDateSpanIterator extends Iterator<DateSpan> {
  final DateSpan dateSpan;

  DateSpan? _current;

  DailyDateSpanIterator(this.dateSpan);

  @override
  DateSpan get current => _current!;

  @override
  bool moveNext() {
    final _start = _current?.end ?? Date(dateSpan.start.year, dateSpan.start.month, dateSpan.start.day);
    if (_start.isAfter(dateSpan.end)) {
      _current = null;
      return false;
    }
    final _end = _start.add(days: 1);

    _current = DateSpan(_start, _end);
    return true;
  }
}

class WeeklyDateSpanIterator extends Iterator<DateSpan> {
  final DateSpan dateSpan;

  DateSpan? _current;

  WeeklyDateSpanIterator(this.dateSpan);

  @override
  DateSpan get current => _current!;

  @override
  bool moveNext() {
    // final dt = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final _start = _current?.end ?? Date(dateSpan.start.year, dateSpan.start.month, 1);
    // final weeklyStart = dt.subtract(Duration(days: dateTime.weekday - 1));
    // final weeklyEnd = dt.add(Duration(days: 7 - dateTime.weekday));

    if (_start.isAfter(dateSpan.end)) {
      _current = null;
      return false;
    }
    final _end = Date(dateSpan.start.year, dateSpan.start.month + 1, 1);

    _current = DateSpan(_start, _end);
    return true;
  }
}

class MonthlyDateSpanIterator extends Iterator<DateSpan> {
  final DateSpan dateSpan;

  DateSpan? _current;

  MonthlyDateSpanIterator(this.dateSpan);

  @override
  DateSpan get current => _current!;

  @override
  bool moveNext() {
    final _start = _current?.end ?? Date(dateSpan.start.year, dateSpan.start.month, 1);
    if (_start.isAfter(dateSpan.end)) {
      _current = null;
      return false;
    }
    final _end = Date(dateSpan.start.year, dateSpan.start.month + 1, 1);

    _current = DateSpan(_start, _end);
    return true;
  }
}
