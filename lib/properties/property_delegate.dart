import 'package:flutter_utils/properties/property_bundle.dart';

/// Created by @RealCradle on 2021/9/2
///

abstract class PropertyDelegate {
  Future setDouble(String name, double value, {String? tag});

  Future setInt(String name, int value, {String? tag});

  Future setBool(String name, bool value, {String? tag});

  Future setString(String name, String value, {String? tag});

  Future<double?> getDoubleOrNull(String name, {double? defValue});

  Future<int?> getIntOrNull(String name, {int? defValue});

  Future<bool?> getBoolOrNull(String name, {bool? defValue});

  Future<String?> getStringOrNull(String name, {String? defValue});

  Future<double> getDouble(String name, {required double defValue});

  Future<int> getInt(String name, {required int defValue});

  Future<bool> getBool(String name, {required bool defValue});

  Future<String> getString(String name, {required String defValue});

  Future remove(String name);

  Future removeAllWithTag(String tag);

  Future<PropertyBundle> loadValuesByTag(String tag);
}

class Properties extends PropertyDelegate {
  static late Properties _instance;

  final PropertyDelegate _delegate;

  static void init(PropertyDelegate delegate) {
    _instance = Properties._(delegate);
  }

  Properties._(PropertyDelegate delegate) : this._delegate = delegate;

  static Properties getInstance() => _instance;

  @override
  Future<bool> getBool(String name, {required bool defValue}) {
    return _delegate.getBool(name, defValue: defValue);
  }

  @override
  Future<bool?> getBoolOrNull(String name, {bool? defValue}) {
    return _delegate.getBoolOrNull(name, defValue: defValue);
  }

  @override
  Future<double> getDouble(String name, {required double defValue}) {
    return _delegate.getDouble(name, defValue: defValue);
  }

  @override
  Future<double?> getDoubleOrNull(String name, {double? defValue}) {
    return _delegate.getDoubleOrNull(name, defValue: defValue);
  }

  @override
  Future<int> getInt(String name, {required int defValue}) {
    return _delegate.getInt(name, defValue: defValue);
  }

  @override
  Future<int?> getIntOrNull(String name, {int? defValue}) {
    return _delegate.getIntOrNull(name, defValue: defValue);
  }

  @override
  Future<String> getString(String name, {required String defValue}) {
    return _delegate.getString(name, defValue: defValue);
  }

  @override
  Future<String?> getStringOrNull(String name, {String? defValue}) {
    return _delegate.getStringOrNull(name, defValue: defValue);
  }

  @override
  Future<PropertyBundle> loadValuesByTag(String tag) {
    return _delegate.loadValuesByTag(tag);
  }

  @override
  Future remove(String name) {
    return _delegate.remove(name);
  }

  @override
  Future removeAllWithTag(String tag) {
    return _delegate.removeAllWithTag(tag);
  }

  @override
  Future setBool(String name, bool value, {String? tag}) {
    return _delegate.setBool(name, value, tag: tag);
  }

  @override
  Future setDouble(String name, double value, {String? tag}) {
    return _delegate.setDouble(name, value, tag: tag);
  }

  @override
  Future setInt(String name, int value, {String? tag}) {
    return _delegate.setInt(name, value, tag: tag);
  }

  @override
  Future setString(String name, String value, {String? tag}) {
    return _delegate.setString(name, value, tag: tag);
  }
}
