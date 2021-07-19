/// Created by @RealCradle on 2021/7/7
///
///

part of "extensions.dart";

extension SubjectExtension<T> on BehaviorSubject<T> {
  void addEx(T event) {
    if (!isClosed) {
      add(event);
    }
  }
}

extension StreamControllerExtension<T> on StreamController<T> {
  void addEx(T event) {
    if (!isClosed) {
      add(event);
    }
  }
}
