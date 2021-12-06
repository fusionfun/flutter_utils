/// Created by @RealCradle on 2021/8/21
///

part of "./router.dart";

class RoutePath {
  final String mainPath;
  final String? segmentSpecifier;

  const RoutePath(this.mainPath, {this.segmentSpecifier});

  String get definedPath {
    String path = mainPath;
    if (segmentSpecifier?.isNotEmpty == true) {
      path += "/:$segmentSpecifier";
    }
    return path;
  }

  String pathUri({String? segmentPath, Map<String, String>? queryParams}) {
    final requestQueryParams = queryParams?.entries.map((e) => "${e.key}=${e.value}").toList() ?? <String>[];
    String path = definedPath;
    if (segmentSpecifier?.isNotEmpty == true) {
      if (segmentPath?.isNotEmpty == true) {
        path = path.replaceAll(":$segmentSpecifier", segmentPath!);
      } else {
        assert(false, "The route($path) need to provide segment path parameters!!");
      }
    }
    requestQueryParams.add(RouteUtils._routeIdQueryParams);
    return "$path?${requestQueryParams.join("&")}";
  }

  String path({String? segmentPath}) {
    String path = definedPath;
    if (segmentSpecifier?.isNotEmpty == true) {
      if (segmentPath?.isNotEmpty == true) {
        path = path.replaceAll(":$segmentSpecifier", segmentPath!);
      } else {
        assert(false, "The route($path) need to provide segment path parameters!!");
      }
    }
    return path;
  }
}
