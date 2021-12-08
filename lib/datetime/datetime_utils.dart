import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_utils/number/number_utils.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/quiver/time.dart';
import 'package:intl/intl.dart';

/// Created by @RealCradle on 2020/5/20
///
///

enum TimeUnit { milliseconds, seconds, minutes, hour, day, month, year, infinite }

/// Signature for a function that creates a widget for a given `day`.
typedef DayBuilder = Widget? Function(BuildContext context, DateTime day);

/// Signature for a function that creates a widget for a given `day`.
/// Additionally, contains the currently focused day.
typedef FocusedDayBuilder = Widget? Function(BuildContext context, DateTime day, DateTime focusedDay);

/// Signature for a function returning text that can be localized and formatted with `DateFormat`.
typedef TextFormatter = String Function(DateTime date, dynamic locale);

/// Gestures available for the calendar.
enum AvailableGestures { none, verticalSwipe, horizontalSwipe, all }

/// Formats that the calendar can display.
enum CalendarFormat { month, twoWeeks, week }

/// Days of the week that the calendar can start with.
enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

final daysFormat = RegExp(r"#d{([^#]*)}");
final hoursFormat = RegExp(r"#h{([^#]*)}");
final minutesFormat = RegExp(r"#m{([^#]*)}");
final secondsFormat = RegExp(r"#s{([^#]*)}");
final millisecondsFormat = RegExp(r"#ms{([^#]*)}");

class DateTimeUtils {
  static final yyyyMMddDateFormat = DateFormat("yyyyMMdd");
  static final yyMMddDateFormat = DateFormat("yyMMdd");
  static final yyyyMMNormalDateFormat = DateFormat("yyyy-MM");
  static final yyyyMMddNormalDateFormat = DateFormat("yyyy-MM-dd");
  static final MMddNormalDateFormat = DateFormat("MM.dd");
  static final standardDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  static final yyyyMMDateFormat = DateFormat("yyyyMM");
  static final MMMDateFormat = DateFormat("MMM");
  static final monthAbbreviatedFormat = DateFormat("MMM");

  static final hamanDateFormat = DateFormat.yMd().add_jm();

  static final standardTimeFormat = DateFormat("HH:mm:ss");

  static const secondInMillis = 1000;
  static const minuteInMillis = secondInMillis * 60;
  static const hourInMillis = secondInMillis * 3600;
  static const sixHourInMillis = hourInMillis * 6;
  static const quarterOfHourInMillis = minuteInMillis * 15;
  static const halfHourInMillis = minuteInMillis * 30;
  static const dayInMillis = hourInMillis * 24;
  static const weekInMillis = dayInMillis * 7;

  static const minuteInSecond = 60;
  static const hourInSecond = 3600;
  static const quarterOfHourInSecond = 900;
  static const halfHourInSecond = 1800;

  static String get yyyyMMdd => yyyyMMddDateFormat.format(DateTime.now());

  static String get yyMMdd => yyMMddDateFormat.format(DateTime.now());

  static String get yyyyMM => yyyyMMDateFormat.format(DateTime.now());

  static String get MMM => MMMDateFormat.format(DateTime.now());

  static String get humanDatetime => hamanDateFormat.format(DateTime.now());

  static String get humanTime => standardTimeFormat.format(DateTime.now());

  static String yyyyMMddBuild(DateTime dateTime) {
    // return yyyyMMddDateFormat.format(dateTime);
    return "${dateTime.year}${NumberUtils.twoDigits(dateTime.month)}${NumberUtils.twoDigits(dateTime.day)}";
  }

  static String yyyyMMBuild(DateTime dateTime) {
    return "${dateTime.year}${NumberUtils.twoDigits(dateTime.month)}";
    // return yyyyMMDateFormat.format(dateTime);
  }

  static String formatMMdd(DateTime dateTime) {
    return "${NumberUtils.twoDigits(dateTime.month)}${NumberUtils.twoDigits(dateTime.day)}";
    // return yyyyMMDateFormat.format(dateTime);
  }

  // static String yyyyMMddNormalBuild(DateTime dateTime) {
  //   return yyyyMMddNormalDateFormat.format(dateTime);
  // }

  static List<DateTime> buildDailyDateTimeGroup() {
    final now = DateTime.now();
    final result = <DateTime>[];
    for (int year = now.year; year >= 2020; year--) {
      int month = (year != now.year) ? 12 : now.month;
      int minMonth = year == 2020 ? 5 : 1;
      for (; month >= minMonth; month--) {
        result.add(DateTime(year, month));
      }
    }
    return result;
  }

  static int currentTimeInSecond() {
    return DateTime.now().millisecondsSinceEpoch.toDouble() ~/ Duration.millisecondsPerSecond;
  }

  static int currentTimeInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int toSecondSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static Duration getDuration(DateTime start, DateTime to) {
    return Duration(milliseconds: to.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
  }

  static Duration remainingDuration() {
    final now = DateTime.now();
    final nextDay = now.add(Duration(days: 1));
    return getDuration(now, DateTime(nextDay.year, nextDay.month, nextDay.day));
  }

  static Duration getDurationForMinutes(int startMinutes, int endMinutes) {
    return Duration(minutes: endMinutes - startMinutes);
  }

  static Duration getDurationForMillis(int start, int end) {
    return Duration(milliseconds: end - start);
  }

  static String formatMilliseconds(int milliseconds) {
    String twoDigitHour = "";
    String twoDigitMinutes = NumberUtils.twoDigits((milliseconds ~/ Duration.millisecondsPerMinute).remainder(Duration.minutesPerHour));
    String twoDigitSeconds = NumberUtils.twoDigits((milliseconds ~/ Duration.millisecondsPerSecond).remainder(Duration.secondsPerMinute));
    if (milliseconds > DateTimeUtils.hourInMillis) {
      twoDigitHour = NumberUtils.twoDigits((milliseconds ~/ Duration.millisecondsPerHour));
      return "$twoDigitHour:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static String formatDurationShort(int milliseconds) {
    final int hour = (milliseconds ~/ Duration.microsecondsPerHour);
    int minute = (milliseconds ~/ Duration.millisecondsPerMinute).remainder(Duration.minutesPerHour);
    int second = (milliseconds ~/ Duration.millisecondsPerSecond).remainder(Duration.secondsPerMinute);
    int millis = milliseconds.remainder(Duration.millisecondsPerSecond);

    if (hour > 0) {
      return "${hour.format(2)}:${minute.format(2)}:${second.format(2)}.${millis.format(3)}";
    } else if (minute > 0) {
      return "${minute.format(2)} m ${second.format(2)}.${millis.format(3)} s";
    } else {
      return "${second.format(2)}.${millis.format(3)} s";
    }
  }

  static String formatSeconds(int seconds) {
    return formatMilliseconds(seconds * 1000);
  }

  static String formatDuration(Duration? duration, {bool verbose = false, TimeUnit minUnit = TimeUnit.day}) {
    if (duration == null) {
      return "--:--:--";
    }

    if (duration.inMicroseconds < 1000) {
      if (verbose != true) {
        return "00:00:00";
      } else {
        return "00 hr 00 min 00 sec";
      }
    }
    if (duration.inDays > 1) {
      String twoDigitHour = NumberUtils.twoDigits(duration.inHours.remainder(Duration.hoursPerDay));
      return "${duration.inDays}d ${twoDigitHour}h";
    }

    String twoDigitMinutes = NumberUtils.twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds = NumberUtils.twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    if (verbose != true) {
      if (minUnit.index >= TimeUnit.hour.index && duration.inHours <= 0) {
        return "00:$twoDigitMinutes:$twoDigitSeconds";
      } else if (duration.inHours < 10) {
        return "${NumberUtils.twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
      } else {
        return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
      }
    } else {
      if (duration.inHours <= 0) {
        return "$twoDigitMinutes min $twoDigitSeconds sec";
      } else if (duration.inHours < 10) {
        return "${NumberUtils.twoDigits(duration.inHours)} hr $twoDigitMinutes min $twoDigitSeconds sec";
      } else {
        return "${duration.inHours} hr $twoDigitMinutes min $twoDigitSeconds sec";
      }
    }
  }

  // {dd} : inDays
  // {hh} : inHours
  // {mm} : inMinutes
  // {ss} : inSeconds
  // {ms} : inMillis remainder per seconds
  static String formatDurationV2(Duration? duration, {String format = "", bool eliminateRedundancy = true}) {
    if (duration == null || duration.inMilliseconds < 1000) {
      return "---";
    }

    int days = duration.inDays > 0 ? duration.inDays : 0;
    int hours = duration.inHours.remainder(Duration.hoursPerDay);
    int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
    int seconds = duration.inSeconds.remainder(Duration.secondsPerMinute);
    int millis = duration.inMilliseconds.remainder(Duration.millisecondsPerSecond);

    bool canIgnore = eliminateRedundancy;
    String result = format;
    final daysMatches = daysFormat.allMatches(result);
    if (daysMatches.length > 0) {
      for (var match in daysMatches) {
        final pattern = match.group(0);
        if (pattern != null) {
          final group = match.groupCount > 0 ? match.group(1) : "";
          if (days > 0) {
            result = result.replaceAll(pattern, "$days$group");
            canIgnore = false;
          } else if (canIgnore) {
            result = result.replaceAll(pattern, "");
          } else {
            result = result.replaceAll(pattern, "00$group");
          }
        }
      }
    } else {
      hours += days * Duration.hoursPerDay;
    }

    final hoursMatches = hoursFormat.allMatches(result);
    if (hoursMatches.length > 0) {
      for (var match in hoursMatches) {
        final pattern = match.group(0);
        if (pattern != null) {
          final group = match.groupCount > 0 ? match.group(1) : "";
          if (hours > 0) {
            result = result.replaceAll(pattern, "${hours.format(2)}$group");
            canIgnore = false;
          } else if (canIgnore) {
            result = result.replaceAll(pattern, "");
          } else {
            result = result.replaceAll(pattern, "00$group");
          }
        }
      }
    } else {
      minutes += hours * Duration.minutesPerHour;
    }

    final minutesMatches = minutesFormat.allMatches(result);
    if (minutesMatches.length > 0) {
      for (var match in minutesMatches) {
        final pattern = match.group(0);
        if (pattern != null) {
          final group = match.groupCount > 0 ? match.group(1) : "";
          if (minutes > 0) {
            result = result.replaceAll(pattern, "${minutes.format(2)}$group");
            canIgnore = false;
          } else if (canIgnore) {
            result = result.replaceAll(pattern, "");
          } else {
            result = result.replaceAll(pattern, "00$group");
          }
        }
      }
    } else {
      seconds += minutes * Duration.secondsPerMinute;
    }

    final secondsMatches = secondsFormat.allMatches(result);
    if (secondsMatches.length > 0) {
      for (var match in secondsMatches) {
        final pattern = match.group(0);
        if (pattern != null) {
          final group = match.groupCount > 0 ? match.group(1) : "";
          if (seconds > 0) {
            result = result.replaceAll(pattern, "${seconds.format(2)}$group");
            canIgnore = false;
          } else if (canIgnore) {
            result = result.replaceAll(pattern, "");
          } else {
            result = result.replaceAll(pattern, "00$group");
          }
        }
      }
    } else {
      millis += minutes * Duration.secondsPerMinute;
    }

    final millisecondsMatches = millisecondsFormat.allMatches(result);
    if (millisecondsMatches.length > 0) {
      for (var match in millisecondsMatches) {
        final pattern = match.group(0);
        if (pattern != null) {
          final group = match.groupCount > 0 ? match.group(1) : "";
          if (millis > 0) {
            result = result.replaceAll(pattern, "${millis.format(3)}$group");
            canIgnore = false;
          } else if (canIgnore) {
            result = result.replaceAll(pattern, "");
          } else {
            result = result.replaceAll(pattern, "00$group");
          }
        }
      }
    } else {
      millis += minutes * Duration.secondsPerMinute;
    }

    return result;
  }

  static List<int> getYearList(int start, [int? end]) {
    final now = DateTime.now();
    final endYear = (end == null || end < start) ? now.year : end;
    final startYear = min(start, endYear);

    return List.generate(endYear - startYear + 1, (year) => year + start);
  }

  static List<DateTime> generateDaysInMonth(int year, int month) {
    final count = daysInMonth(year, month);
    final List<DateTime> result = [];
    for (int day = 1; day <= count; ++day) {
      result.add(DateTime(year, month, day));
    }
    return result;
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static int getDayCountOfMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    return DateTime(year, month + 1, 0).day;
  }

  /// Returns a numerical value associated with given `weekday`.
  ///
  /// Returns 1 for `StartingDayOfWeek.monday`, all the way to 7 for `StartingDayOfWeek.sunday`.
  static int getWeekdayNumber(StartingDayOfWeek weekday) {
    return StartingDayOfWeek.values.indexOf(weekday) + 1;
  }

  /// Returns `date` in UTC format, without its time part.
  static DateTime normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  /// Checks if two DateTime objects are the same day.
  /// Returns `false` if either of them is null.
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month;
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  static int getRowCount(DateTime focusedDay) {
    final first = _firstDayOfMonth(focusedDay);
    final daysBefore = getDaysBefore(first);
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = lastDayOfMonth(focusedDay);
    final daysAfter = getDaysAfter(last);
    final lastToDisplay = last.add(Duration(days: daysAfter));

    return (lastToDisplay.difference(firstToDisplay).inDays + 1) ~/ 7;
  }

  static DateTime _firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month, 1);
  }

  static int getDaysBefore(DateTime firstDay) {
    return (firstDay.weekday + 7 - getWeekdayNumber(StartingDayOfWeek.sunday)) % 7;
  }

  static DateTime lastDayOfMonth(DateTime month) {
    final date = month.month < 12 ? DateTime.utc(month.year, month.month + 1, 1) : DateTime.utc(month.year + 1, 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  static int getDaysAfter(DateTime lastDay) {
    int invertedStartingWeekday = 8 - getWeekdayNumber(StartingDayOfWeek.sunday);

    int daysAfter = 7 - ((lastDay.weekday + invertedStartingWeekday) % 7);
    if (daysAfter == 7) {
      daysAfter = 0;
    }

    return daysAfter;
  }
}

class DailyMonthGroup {
  final DateTime dateTime;
  final int year;
  final int month;

  DailyMonthGroup(this.dateTime, this.year, this.month);
}
