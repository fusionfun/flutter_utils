import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

///
/// Created by @RealCradle on 2021/7/6
///

class DeviceUtils {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static final List<SystemUiOverlay> _latestOverlays = [SystemUiOverlay.top, SystemUiOverlay.bottom];

  //
  static bool? realTablet;

  static void setEnabledSystemUIOverlays(List<SystemUiOverlay> overlays) {
    if (_latestOverlays != overlays) {
      SystemChrome.setEnabledSystemUIOverlays(overlays);
      _latestOverlays.clear();
      if (overlays.isNotEmpty == true) {
        _latestOverlays.addAll(overlays);
      }
    }
  }

  static bool isTablet() {
    if (realTablet != null) {
      return realTablet!;
    }
    final ui.Size physicalSize = ui.window.physicalSize;
    if (ui.window.devicePixelRatio < 2 && (physicalSize.width >= 1000 || physicalSize.height >= 1000)) {
      return true;
    } else if (ui.window.devicePixelRatio == 2 && (physicalSize.width >= 1920 || physicalSize.height >= 1920)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isOutdatedTablet() async {
    if (isTablet()) {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        print("isOutdatedTablet android: ${info.version.sdkInt}");
        return info.version.sdkInt < 24;
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        final versions = info.systemVersion.split(".");
        print("isOutdatedTablet ios: $versions");
        return int.parse(versions[0]) < 13;
      }
    }
    return false;
  }

  static Future<bool> isGreaterThanOrEqualIOS14() async {
    if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      final versions = info.systemVersion.split(".");
      return int.parse(versions[0]) >= 14;
    } else {
      return false;
    }
  }
}
