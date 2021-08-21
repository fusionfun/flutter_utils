part of "router.dart";

class RouteEntry {
  final Route route;
  final Uri routeUri;

  String get routeId => routeUri.queryParameters["_route_id"]!;

  RouteEntry _clone() {
    return RouteEntry._clone(route, routeUri);
  }

  bool isSameRoute(RouteEntry entry) {
    return routeUri == entry.routeUri;
  }

  bool isSameName(String? name) {
    return routeUri.toString() == name;
  }

  @override
  String toString() {
    return 'RouteEntry{routePath: $routeUri, route: $route}';
  }

  RouteEntry._clone(this.route, this.routeUri);

  RouteEntry(this.route) : this.routeUri = Uri.parse(route.settings.name ?? RouteUtils.anonymous);
}

class RouteStack {
  final List<RouteEntry> entries = [];

  RouteStack();

  RouteStack clone() => RouteStack()..entries.addAll(entries);

  void push(Route route) {
    entries.add(RouteEntry(route));
  }

  Route? pop() {
    return entries.isNotEmpty ? entries.removeLast().route : null;
  }

  void remove(Route route) {
    entries.removeWhere((entry) => entry.route.hashCode == route.hashCode);
  }

  bool get isNotEmpty => entries.isNotEmpty;

  void dumpStack({String? summary}) {
    var index = entries.length;
    debugPrint("### BEGIN ### dumpStack() ${summary != null ? "[$summary]" : ""}");
    for (final value in entries.reversed) {
      debugPrint(" [${index--}] ==> [${value.route.hashCode}] ${value.routeUri} ");
    }
    debugPrint("### END ### dumpStack()");
  }

  bool isTopEntry(RouteEntry entry) {
    return (entries.isEmpty && entry.routeUri.path == '/') || entry.isSameRoute(entries.last);
  }

  RouteEntry? top() {
    return (entries.isNotEmpty == true) ? entries.last : null;
  }

  RouteEntry? tail() {
    return (entries.isNotEmpty == true) ? entries.first : null;
  }

  RouteEntry? firstWhere(bool test(RouteEntry element), {RouteEntry orElse()?}) {
    return entries.firstWhere((element) => test(element), orElse: orElse);
  }

//
//  bool hasPath(RoutePath path) {
//    final entry = entries.firstWhere((entry) {
//      return entry.routePath == path;
//    }, orElse: () => null);
//    return entry != null;
//  }
//
//  RoutePath peekPrevPath(RoutePath path) {
//    int index = _items.length - 1;
//    for (final item in _items.reversed) {
//      if (item.routePath.path == path.path) {
//        break;
//      }
//      index--;
//    }
//    if (index > 0) {
//      return _items[index - 1].routePath;
//    } else {
//      return null;
//    }
//  }
}

class GlobalRoutesObserver extends RouteObserver {
  static GlobalRoutesObserver? _instance;

  final RouteStack _stack = RouteStack();

  static GlobalRoutesObserver _getInstance() {
    if (_instance == null) {
      _instance = GlobalRoutesObserver._internal();
    }
    return _instance!;
  }

  GlobalRoutesObserver._internal();

  factory GlobalRoutesObserver() => _getInstance();

  static GlobalRoutesObserver get instance => _getInstance();

  final BehaviorSubject<RouteStack> _routeStackController = BehaviorSubject<RouteStack>.seeded(RouteStack());

  Stream<RouteStack> get observableRouteStack => _routeStackController.asBroadcastStream();

  RouteEntry? get top => _stack.top()?._clone();

  RouteEntry? firstWhere(bool test(RouteEntry element), {RouteEntry orElse()?}) {
    return _stack.firstWhere((element) => test(element), orElse: orElse);
  }

  bool _isSameRoute(Route<dynamic>? route1, Route<dynamic>? route2) {
    return route1?.hashCode == route2?.hashCode;
  }

  bool isTopEntry(RouteEntry entry) {
    return _stack.isTopEntry(entry);
  }

  void _push(Route route) {
    _stack.push(route);
  }

  void _remove(Route route) {
    _stack.remove(route);
  }

  Route? _pop() {
    return _stack.pop();
  }

  void _replace(Route<dynamic>? src, Route<dynamic>? dst) {
    Route? route;
    do {
      route = _pop();
    } while (route != null && !_isSameRoute(route, src));
    if (dst != null) {
      _push(dst);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _pop();
    var previousName = previousRoute?.settings.name ?? "unknown";
    debugPrint(
        "==> [didPop][previousRoute] name:$previousName first:${previousRoute?.isFirst ?? "-"} current:${previousRoute?.isCurrent ?? "-"} active:${previousRoute?.isActive ?? "-"} hashCode:${previousRoute?.hashCode ?? "-"}");

    dispatchStack(summary: "didPop");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null) {
      final topEntry = _stack.top();
      debugPrint("didPush previousRoute:${previousRoute.settings.name} top:${topEntry?.routeUri}");
      if (topEntry?.route.hashCode != previousRoute.hashCode && topEntry?.isSameName(previousRoute.settings.name) != true) {
        _push(previousRoute);
      }
    } else {
      final tailEntry = _stack.tail();
      if (tailEntry?.isSameName("/") == true) {
        debugPrint("didPush previousRoute is null, has existed! ${tailEntry?.routeUri}");
        dispatchStack(summary: "didPush ignore");
        return;
      }
    }
    _push(route);
    dispatchStack(summary: "didPush");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _remove(route);
    dispatchStack(summary: "didRemove");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint("newRoute: $newRoute ${newRoute.hashCode} oldRoute:$oldRoute ${oldRoute.hashCode}");
    _replace(oldRoute, newRoute);
    dispatchStack(summary: "didReplace");
  }

  void dispatchStack({String? summary}) {
    final stack = _stack.clone(); //..dumpStack(summary: summary);
    _routeStackController.add(stack);
  }
}
