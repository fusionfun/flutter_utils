import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Created by @RealCradle on 2021/7/7
///

class ScreenHelper {
  static ScreenHelper _instance = ScreenHelper._internal();

  factory ScreenHelper() => _instance;

  ScreenHelper._internal();

  late MediaQueryData _deviceMediaQueryData;

  void init(BuildContext context) {
    _deviceMediaQueryData = MediaQuery.of(context);
  }

  double get bottomBarHeight => _deviceMediaQueryData.padding.bottom;

  double get statusBarHeight => _deviceMediaQueryData.padding.top;

  EdgeInsets get safeAreaPadding => _deviceMediaQueryData.padding;

  Size get screenSize => _deviceMediaQueryData.size;

  EdgeInsets get pageDialogInsetPadding {
    final size = _deviceMediaQueryData.size;
    // if (size == null) {
    //   return EdgeInsets.all(120);
    // }

    return EdgeInsets.symmetric(vertical: size.height / 6, horizontal: size.width / 6);
  }

  EdgeInsets get pageDialogInsetVerticalPadding {
    final size = _deviceMediaQueryData.size;
    if (size == null) {
      return EdgeInsets.symmetric(vertical: 120);
    }

    return EdgeInsets.symmetric(vertical: size.height / 6);
  }

  EdgeInsets get pageDialogInsetHorizontalPadding {
    final size = _deviceMediaQueryData.size;
    if (size == null) {
      return EdgeInsets.symmetric(horizontal: 48);
    }

    return EdgeInsets.symmetric(horizontal: size.width / 6);
  }

  EdgeInsets get pageDialogInsetPaddingForCoinsStoreNewPage {
    final size = _deviceMediaQueryData.size;
    // if (size == null) {
    //   return EdgeInsets.all(120);
    // }

    return EdgeInsets.symmetric(vertical: size.height / 10, horizontal: size.width / 6);
  }

  static Future<Size> initialDimensions() async {
    // https://github.com/flutter/flutter/issues/5259
    // "In release mode we start off at 0x0 but we don't in debug mode"
    return await Future<Size>(() {
      if (window.physicalSize.isEmpty) {
        final completer = Completer<Size>();
        window.onMetricsChanged = () {
          if (!window.physicalSize.isEmpty && !completer.isCompleted) {
            completer.complete(window.physicalSize / window.devicePixelRatio);
          }
        };
        return completer.future;
      }
      return window.physicalSize / window.devicePixelRatio;
    });
  }
}
