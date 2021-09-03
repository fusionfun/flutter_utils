/// Created by @RealCradle on 4/19/21

class PropertyBundle {
  final Map<String, String> data;

  PropertyBundle({Map<String, String>? map}) : data = <String, String>{} {
    if (map != null) {
      this.data.addAll(map);
    }
  }

  PropertyBundle.empty() : this.data = const <String, String>{};

  void setInt(String key, int value) {
    data[key] = value.toString();
  }

  void setDouble(String key, double value) {
    data[key] = value.toString();
  }

  void setString(String key, String value) {
    data[key] = value;
  }

  void setBool(String key, bool value) {
    data[key] = value ? "1" : "0";
  }

  int? getInt(String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    return int.parse(value);
  }

  double? getDouble(String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    return double.parse(value);
  }

  String? getString(String key) {
    return data[key];
  }

  bool? getBool(String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    return value == "1";
  }

  void forEach(void f(String key, String value)) {
    data.entries.forEach((entry) {
      f.call(entry.key, entry.value);
    });
  }
}
