import 'dart:math';

/// Created by @RealCradle on 2021/7/7
///

class RandomUtils {
  static Random _random = Random(DateTime.now().microsecondsSinceEpoch);

  static int nextInt(int max) {
    return _random.nextInt(max);
  }

  static double nextDouble() {
    return _random.nextDouble();
  }
}
