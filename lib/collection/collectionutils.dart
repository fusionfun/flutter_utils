/// Created by @RealCradle on 2020/5/27
///

class CollectionUtils {
  static Map<String, dynamic> filterOutNulls(Map<String, dynamic> parameters) {
    final Map<String, dynamic> filtered = <String, dynamic>{};
    parameters.forEach((String key, dynamic value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  static dynamic checkAndGet(Map<String, dynamic> map, String key, [dynamic defaultValue]) {
    return ((map != null) ? map[key] : defaultValue) ?? defaultValue;
  }

  static Map<String, dynamic> modifyMap(Map<String, dynamic> src,
      {List<String>? removeKeys, Map<String, dynamic>? replaceMap, bool create = true}) {
    return (create ? Map.from(src) : src)
      ..addAll(replaceMap ?? <String, dynamic>{})
      ..removeWhere((key, value) {
        return removeKeys != null && removeKeys.contains(key);
      });
  }

  static List foreachJsonList(List list, bool predicate(dynamic key, dynamic value),
      dynamic replace(dynamic key, dynamic value)) {
    List result = [];
    for (var item in list) {
      dynamic value = item;
      if (item is Map) {
        value = foreachJsonMap(item as Map<String,dynamic>, predicate, replace);
      } else if (item is List) {
        value = foreachJsonList(item, predicate, replace);
      }
      result.add(value);
    }
    return result;
  }

  static Map<String, dynamic> foreachJsonMap(Map<String, dynamic> map,
      bool predicate(dynamic key, dynamic value), dynamic replace(dynamic key, dynamic value)) {
    final result = Map.of(map);
    for (var entry in map.entries) {
      final needReplace = predicate(entry.key, entry.value);
      if (needReplace) {
        result[entry.key] = replace(entry.key, entry.value);
        continue;
      }
      if (entry.value is Map) {
        result[entry.key] = foreachJsonMap(entry.value, predicate, replace);
      } else if (entry.value is List) {
        result[entry.key] = foreachJsonList(entry.value, predicate, replace);
      }
    }
    return result;
  }
}

class ListUtils {
  static List<T> filterOutNulls<T>(List<T?> data) {
    final List<T> filtered = [];
    data.forEach((T? item) {
      if (item != null) {
        filtered.add(item);
      }
    });
    return filtered;
  }
}

class MapUtils {}
