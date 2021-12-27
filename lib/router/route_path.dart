/// Created by @RealCradle on 2021/8/21
///

part of "./router.dart";

class RoutePath {
  final String name;
  final bool segmentSpecifier;
  final RoutePath? parentPath;

  const RoutePath(this.name, {this.segmentSpecifier = false, this.parentPath});

  String get _path {
    return "${parentPath?.path ?? ""}$mainPath";
  }

  String get mainPath {
    return "/${segmentSpecifier ? ":" : ""}$name";
  }

  String path({String? segmentPath, Map<String, String>? queryParams}) {
    final requestQueryParams = queryParams?.entries.map((e) => "${e.key}=${e.value}").toList() ?? <String>[];
    String path = _path;

    if (segmentSpecifier) {
      if (segmentPath != null) {
        path = path.replaceAll(":$segmentSpecifier", segmentPath);
      } else {
        assert(false, "The route($path) need to provide segment path parameters!!");
      }
    }
    return "$path${queryParams?.isNotEmpty == true ? "?${requestQueryParams.join("&")}" : ''}";
  }
}
