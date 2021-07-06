/// Created by Haoyi on 4/13/21
///
class NumberUtils {
  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String fourDigits(int n) {
    if (n >= 1000) return "$n";
    if (n >= 100) return "0$n";
    if (n >= 10) return "00$n";
    return "000$n";
  }

  static String fiveDigits(int n) {
    if (n >= 10000) return "$n";
    if (n >= 1000) return "0$n";
    if (n >= 100) return "00$n";
    if (n >= 10) return "000$n";
    return "0000$n";
  }

  static String sixDigits(int n) {
    if (n >= 100000) return "$n";
    if (n >= 10000) return "0$n";
    if (n >= 1000) return "00$n";
    if (n >= 100) return "000$n";
    if (n >= 10) return "0000$n";
    return "00000$n";
  }

  static String eightDigits(int n) {
    if (n >= 10000000) return "$n";
    if (n >= 1000000) return "0$n";
    if (n >= 100000) return "00$n";
    if (n >= 10000) return "000$n";
    if (n >= 1000) return "0000$n";
    if (n >= 100) return "00000$n";
    if (n >= 10) return "000000$n";
    return "0000000$n";
  }

  static String tenDigits(int n) {
    if (n >= 1000000000) return "$n";
    if (n >= 100000000) return "0$n";
    if (n >= 10000000) return "00$n";
    if (n >= 1000000) return "000$n";
    if (n >= 100000) return "0000$n";
    if (n >= 10000) return "00000$n";
    if (n >= 1000) return "000000$n";
    if (n >= 100) return "0000000$n";
    if (n >= 10) return "00000000$n";
    return "000000000$n";
  }
}
