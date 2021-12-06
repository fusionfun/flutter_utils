import 'dart:convert';

import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/properties/property_bundle.dart';
import 'package:flutter_utils/properties/property_delegate.dart';

/// Created by @RealCradle on 2021/9/2

abstract class PropertyData<T> {
  static final Map<String, PropertyData> properties = {};
  final T defaultValue;
  final String name;
  final BehaviorSubject<T> subject;

  Stream<T> observe() => subject.stream;

  PropertyData(this.name, {required this.defaultValue}) : this.subject = BehaviorSubject.seeded(defaultValue) {
    properties[name] = this;
  }

  void init(PropertyBundle bundle);

  void set(T? data) {
    subject.addEx(data ?? defaultValue);
  }

  T get({T? overrideDefaultValue}) {
    return subject.value ?? overrideDefaultValue ?? defaultValue;
  }
}

class PropertyIntData extends PropertyData<int> {
  PropertyIntData(String name, {required int defaultValue}) : super(name, defaultValue: defaultValue);

  void set(int? data, {String? tag}) {
    super.set(data);
    if (data == null) {
      Properties.getInstance().remove(name);
    } else {
      Properties.getInstance().setInt(name, data, tag: tag);
    }
  }

  @override
  void init(PropertyBundle bundle) {
    super.set(bundle.getInt(name));
  }
}

class PropertyDoubleData extends PropertyData<double> {
  PropertyDoubleData(String name, {required double defaultValue}) : super(name, defaultValue: defaultValue);

  @override
  void init(PropertyBundle bundle) {
    super.set(bundle.getDouble(name));
  }

  void set(double? data, {String? tag}) {
    super.set(data);
    if (data == null) {
      Properties.getInstance().remove(name);
    } else {
      Properties.getInstance().setDouble(name, data, tag: tag);
    }
  }
}

class PropertyStringData extends PropertyData<String> {
  PropertyStringData(String name, {required String defaultValue}) : super(name, defaultValue: defaultValue);

  @override
  void init(PropertyBundle bundle) {
    super.set(bundle.getString(name));
  }

  void set(String? data, {String? tag}) {
    super.set(data);
    if (data == null) {
      Properties.getInstance().remove(name);
    } else {
      Properties.getInstance().setString(name, data, tag: tag);
    }
  }
}

class PropertyBoolData extends PropertyData<bool> {
  PropertyBoolData(String name, {required bool defaultValue}) : super(name, defaultValue: defaultValue);

  @override
  void init(PropertyBundle bundle) {
    super.set(bundle.getBool(name));
  }

  void set(bool? data, {String? tag}) {
    super.set(data);
    if (data == null) {
      Properties.getInstance().remove(name);
    } else {
      Properties.getInstance().setBool(name, data, tag: tag);
    }
  }
}

class PropertyJsonData<T> extends PropertyData<T> {
  final T Function(Map<String, dynamic>) decoder;

  PropertyJsonData(String name, {required this.decoder, required T defaultValue}) : super(name, defaultValue: defaultValue);

  @override
  void init(PropertyBundle bundle) {
    final jsonStr = bundle.getString(name);
    if (jsonStr != null) {
      try {
        final jsonMap = json.decode(jsonStr);
        super.set(decoder.call(jsonMap));
        return;
      } catch (error, stacktrace) {
        print("init PropertyJsonData error:$error, $stacktrace");
        super.set(defaultValue);
      }
    }
    super.set(defaultValue);
  }

  void set(T? data, {String? tag}) {
    super.set(data);
    if (data == null) {
      Properties.getInstance().remove(name);
    } else {
      final jsonData = json.encode(data);
      Properties.getInstance().setString(name, jsonData, tag: tag);
    }
  }
}
