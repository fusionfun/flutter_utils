import 'dart:collection';

import 'package:flutter_utils/datetime/datetime_utils.dart';
import 'package:logger/logger.dart';

/// Created by @RealCradle on 2021/7/7
///
///
enum LogMode { simple, pretty, none }

class LogUtils {
  static Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static int recordCount = 0;
  static LogMode mode = LogMode.pretty;
  static final DoubleLinkedQueue<MapEntry<String, String>> latestLogRecords = DoubleLinkedQueue();

  static void _simplePrint(String msg, {String? tag}) {
    print("[$tag] $msg");
  }

  static void recordLog(String msg, {bool dump = true, StackTrace? stackTrace}) async {
    recordCount++;
    latestLogRecords.addFirst(MapEntry("[$recordCount] ${DateTimeUtils.humanTime}", msg));
    if (latestLogRecords.length > 300) {
      latestLogRecords.removeLast();
    }
    if (dump) {
      print("$msg ${stackTrace ?? ""}");
    }
  }


  static void v(String msg, {String? tag}) {
    switch (mode) {
      case LogMode.simple:
        _simplePrint(msg);
        break;
      case LogMode.pretty:
        if (tag == null) {
          _logger.v("$msg");
        } else {
          _logger.v("[$tag] $msg");
        }
        break;
      default:
        return;
    }
  }

  static void d(String msg, {String? tag}) {
    switch (mode) {
      case LogMode.simple:
        _simplePrint(msg, tag: tag);
        break;
      case LogMode.pretty:
        if (tag == null) {
          _logger.d("$msg");
        } else {
          _logger.d("[$tag] $msg");
        }
        break;
      default:
        return;
    }
  }

  static void i(String msg, {String? tag}) {
    switch (mode) {
      case LogMode.simple:
        _simplePrint(msg);
        break;
      case LogMode.pretty:
        if (tag == null) {
          _logger.i("$msg");
        } else {
          _logger.i("[$tag] $msg");
        }
        break;
      default:
        return;
    }
  }

  static void w(String msg, {String? tag}) {
    switch (mode) {
      case LogMode.simple:
        _simplePrint(msg);
        break;
      case LogMode.pretty:
        if (tag == null) {
          _logger.w("$msg");
        } else {
          _logger.w("[$tag] $msg");
        }
        break;
      default:
        return;
    }
  }

  static void e(String msg, {String? tag}) {
    switch (mode) {
      case LogMode.simple:
        _simplePrint(msg);
        break;
      case LogMode.pretty:
        if (tag == null) {
          _logger.e("$msg");
        } else {
          _logger.e("[$tag] $msg");
        }
        break;
      default:
        return;
    }
  }
}
