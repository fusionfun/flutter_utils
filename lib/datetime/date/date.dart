/// Created by @RealCradle on 2021/8/5

class Date {
  int get year => _datetime.year;

  int get month => _datetime.month;

  int get day => _datetime.day;

  int get weekday => _datetime.weekday;

  final DateTime _datetime;

  Date._(DateTime dateTime) : _datetime = dateTime;

  Date(int year, [int month = 1, int day = 1]) : _datetime = DateTime(year, month, day);

  Date.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch) :_datetime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

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

  int differenceDays(Date date) {
    return _datetime
        .difference(date._datetime)
        .inDays;
  }
}
