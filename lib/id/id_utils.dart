import 'dart:math';

import 'package:uuid/uuid.dart';

/// Created by @RealCradle on 2021/7/7

class IdUtils {
  static const _ORIGINAL_ALPHABET =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static const _BASE36_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyz';

  static const _ORIGINAL_CODE = 'Y3JUXK9FC2SAV8ZE5HW6BQDTP7MNLG4R';

  static final mask = (2 << log(_ORIGINAL_ALPHABET.length - 1) ~/ ln2) - 1;

  static final magicNumber = 0x9E370001;

  static Uuid _uuid = Uuid();
  static Random _random = Random(DateTime.now().microsecondsSinceEpoch);

  static String padBlank(String codes, int maxLength) {
    print("sb.length:${codes.length} $maxLength");
    if (codes.length < maxLength) {
      final count = maxLength - codes.length;
      for (int index = 0; index < count; ++index) {
        codes = "${_ORIGINAL_CODE[0]}$codes";
      }
    }
    return codes;
  }

  static String numToCode(int num, int maxLen, {bool padding = true}) {
    if (num < 0) {
      return "";
    }
    String codes = "";
    int cn = num;
    while ((cn ~/ _ORIGINAL_CODE.length) > 0) {
      final index = cn % _ORIGINAL_CODE.length;
      codes = "$codes${_ORIGINAL_CODE[index]}";
      cn = cn ~/ _ORIGINAL_CODE.length;
    }
    final tailIndex = cn % _ORIGINAL_CODE.length;
    if (tailIndex > 0) {
      codes = "$codes${_ORIGINAL_CODE[tailIndex]}";
    }
    if (padding) {
      codes = padBlank(codes, maxLen);
    }
    return codes;
  }

  static List<int> _randomBytes(int size) {
    final bytes = <int>[];
    for (var i = 0; i < size; i++) {
      bytes.add((_random.nextDouble() * 256).floor());
    }
    return bytes;
  }

  static List<int> uuidBytes() {
    final buffer = List.filled(16, 0);
    _uuid.v4buffer(buffer);
    return buffer;
  }

  static String keyUuid(String key) {
    return _uuid.v5(Uuid.NAMESPACE_URL, key);
  }

  static int randomInt(int max) {
    return _random.nextInt(max);
  }

  static int mergeBytesToHashCode(List<int> data) {
    return data.reduce((value, element) => element * 31 + value);
  }

  static int randomUuidHashCode() {
    final bytes = uuidBytes();
    bytes.shuffle();
    return mergeBytesToHashCode(bytes);
  }

  static String randomBase36Text(int length) {
    return List.generate(length, (index) => _BASE36_ALPHABET[_random.nextInt(36)]).join();
  }

  static String uuidV4() => _uuid.v4();

  static String generate(int size) {
    final seed = uuidBytes();
    final step = (1.6 * mask * size / _ORIGINAL_ALPHABET.length).ceil();
    var id = '';
    const faker = true;
    while (faker) {
      final bytes = _randomBytes(step);
      seed.shuffle();
      int hashValue = 0;
      for (var i = 0; i < step; i++) {
        hashValue = hashValue * 17 + (bytes[i] + seed[i % 16]) * 17;
        final byte = hashValue & mask;
        if (byte > 0 && _ORIGINAL_ALPHABET.length > byte) {
          id += _ORIGINAL_ALPHABET[byte];
          if (id.length == size) {
            return id;
          }
        }
      }
    }
    return '';
  }
}
