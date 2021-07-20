import 'package:flutter/material.dart';

/// Created by @RealCradle on 4/28/21

class ColorUtils {
  static Color toColor(String? colorStr, {Color defaultColor = Colors.white}) {
    if (colorStr == null) {
      return defaultColor;
    }
    String colorValue = colorStr.toUpperCase().replaceAll("#", "");
    int value = int.parse(colorValue, radix: 16);
    if (colorValue.length == 3) {
      return Color.fromARGB(
          0xFF,
          ((((value >> 8) & 0x0F) / 0x0F) * 0xFF).toInt(),
          ((((value >> 4) & 0x0F) / 0x0F) * 0xFF).toInt(),
          (((value & 0x0F) / 0x0F) * 0xFF).toInt());
    }
    if (colorValue.length == 6) {
      value = value | 0xFF000000;
    }

    return Color(value);
  }
}
