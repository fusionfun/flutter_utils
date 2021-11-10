/// Created by RealCradle on 2021/9/14

class PseudoRandom {
  static const _RAND_MAX = 0x7FFFFFFF;
  static const _RAND_INIT = 123459876;

  int _next = 1;

  final int seed;

  PseudoRandom([int? seed])
      : seed = seed ?? _RAND_INIT,
        _next = seed ?? _RAND_INIT;

  int _rand() {
    if (_next == 0) {
      _next = _RAND_INIT;
    }
    final int quotient = _next ~/ 127773;
    final int remainder = _next % 127773;
    int t = 16807 * remainder - 2836 * quotient;
    if (t <= 0) {
      t += _RAND_MAX;
    }
    _next = t % (_RAND_MAX + 1);
    return _next;
  }

  int nextInt([int? max]) {
    return _rand() % (max ?? _RAND_MAX);
  }

  bool nextBool() {
    return _rand() & 0x01 == 1;
  }

  void shuffle(List list) {
    var i = list.length;
    while (i > 1) {
      int pos = nextInt(i);
      i -= 1;
      var tmp = list[i];
      list[i] = list[pos];
      list[pos] = tmp;
    }
  }
}
