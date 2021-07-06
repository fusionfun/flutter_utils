import 'dart:math';

/// Created by @RealCradle on 2021/7/7
///
class MathUtils {
  static double toRadian(double angle) {
    return angle * (pi / 180.0);
  }

  static double toAngle(double radian) {
    return radian * (180.0 / pi);
  }

  static const _fibonacci_array = [
    1,
    1,
    2,
    3,
    5,
    8,
    13,
    21,
    34,
    55,
    89,
    144,
    233,
    377,
    610,
    987,
    1597,
    2584,
    4181,
    6765,
    10946,
    17711,
    28657,
    46368,
    75025,
    121393,
    196418,
    317811,
    514229,
    832040,
    1346269,
    2178309,
    3524578,
    5702887,
    9227465,
    14930352,
    24157817,
    39088169,
    63245986,
    102334155,
    165580141,
    267914296,
    433494437,
    701408733,
    1134903170,
    1836311903,
    2971215073,
    4807526976,
    7778742049,
    12586269025
  ];

  static int fibonacci(int n) {
    final len = _fibonacci_array.length;
    if (n < len) {
      return _fibonacci_array[n];
    }
    int n1 = _fibonacci_array[len - 2], n2 = _fibonacci_array[len - 1], sum = 0;
    for (int i = _fibonacci_array.length; i <= n; i++) {
      sum = n1 + n2;
      n1 = n2;
      n2 = sum;
    }
    return sum;
  }
}
