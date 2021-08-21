/// Created by @RealCradle on 2021/8/21
///
///

part of "router.dart";

class RouteMatcher {
  final UriChecker checker;
  final PathDispatcher dispatcher;

  RouteMatcher({required this.checker, required this.dispatcher});
}
