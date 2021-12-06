import 'dart:typed_data';

import 'package:flutter_utils/hash/hash.dart';


/// Created by @RealCradle on 4/13/21

class IntArray {
  int head = 0;
  int tail = 0;

  final List<int> data;

  IntArray() : this.data = <int>[];

  IntArray.fromUint8List(Uint8List list) : data = list.buffer.asUint32List().toList() {
    head = 0;
    tail = data.length;
  }

  void set(int index, int value) {
    data[index] = value;
  }

  int get(int index) => data[index];

  int write(int value) {
    data.add(value);
    return tail++;
  }

  int writeAll(List<int> values) {
    data.addAll(values);
    final start = tail;
    tail += values.length;
    return start;
  }

  int? read() {
    if (head != tail && head < tail) {
      return data[head++];
    }
    return null;
  }

  int get remains => tail - head;

  List<int> readAll(int length) {
    final r = remains;
    if (r >= length) {
      print("readAll length:$length");
      final start = head;
      final end = head + length;
      head = end;
      return data.sublist(start, end);
    }
    return [];
  }

  Uint8List asUint8List() {
    return Uint32List.fromList(data).buffer.asUint8List();
  }

  int checksum({int offset = 0}) {
    int hash = 0x9E370001;
    for (int index = offset; index < data.length; ++index) {
      hash = hashCombine(hash, data[index]);
    }
    return hashFinish(hash);
  }
}
