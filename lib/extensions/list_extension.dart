/// Created by @RealCradle on 2021/7/7

part of "extensions.dart";

extension ListExtension<T> on List<T> {
  T? get safeLast => isEmpty ? null : last;

  T? get safeFirst => isEmpty ? null : first;

  int get lastIndex => length - 1;
}
