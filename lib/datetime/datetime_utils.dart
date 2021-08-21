import 'package:flutter_utils/number/number_utils.dart';
import 'package:intl/intl.dart';

/// Created by @RealCradle on 2020/5/20
///
///

enum TimeUnit { milliseconds, seconds, minutes, hour, day, month, year, infinite }

class DateTimeUtils {
  static final yyyyMMddDateFormat = DateFormat("yyyyMMdd");
  static final yyMMddDateFormat = DateFormat("yyMMdd");
  static final yyyyMMNormalDateFormat = DateFormat("yyyy-MM");
  static final yyyyMMddNormalDateFormat = DateFormat("yyyy-MM-dd");
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
      twoDigitHour = NumberUtils.twoDigits((milliseconds ~/ Duration.millisecondsPerHour).remainder(Duration.minutesPerHour));
      return "$twoDigitHour:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
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

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static int getDayCountOfMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    return DateTime(year, month + 1, 0).day;
  }
}

class DailyMonthGroup {
  final DateTime dateTime;
  final int year;
  final int month;

  DailyMonthGroup(this.dateTime, this.year, this.month);
}
