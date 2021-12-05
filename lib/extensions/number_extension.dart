/// Created by @RealCradle on 2021/12/5

part of "extensions.dart";

List<String Function(int n)> _converts = [
  NumberUtils.twoDigits,
  NumberUtils.threeDigits,
  NumberUtils.fourDigits,
  NumberUtils.fiveDigits,
  NumberUtils.sixDigits,
  NumberUtils.sevenDigits,
  NumberUtils.eightDigits,
  NumberUtils.nineDigits,
  NumberUtils.tenDigits
];

extension IntExtension<T> on int {
  String format(int digits) {
    if (digits - 2 < _converts.length) {
      return _converts[digits - 2](this);
    }
    return NumberUtils.nDigits(this, digits);
  }
}
