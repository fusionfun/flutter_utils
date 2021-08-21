/// Created by Haoyi on 2021/8/21

part of "./router.dart";

class RouteUtils {
  static int _routeId = 0;

  static String _generateRouteId() {
    return "${NumberUtils.eightDigits(_routeId++)}";
  }

  static String get _routeIdQueryParams => "_route_id=${_generateRouteId()}";

  static String get anonymous => "/${IdUtils.uuidV4()}?$_routeIdQueryParams";

  static String convertUri(Uri uri) {
    return "${uri.path}?${uri.query}&$_routeIdQueryParams";
  }

  static String convertPath(String path) {
    return "$path?$_routeIdQueryParams";
  }

  static Map<String, List<String>> convertQueryParamsToRouteParams(Map<String, String> params) {
    return Map.fromEntries(params.entries.map((entry) => MapEntry(entry.key, [entry.value])).toList());
  }
}
