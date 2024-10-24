import 'package:dbus/dbus.dart';
import 'package:flutter/foundation.dart';
import 'package:gsettings/gsettings.dart';

class GSettingsService {
  final _settings = <String, GnomeSettings?>{};

  GnomeSettings? lookup(String schemaId, {String? path}) {
    try {
      return _settings[schemaId] ??= GnomeSettings(schemaId, path: path);
    } on GSettingsSchemaNotInstalledException catch (_) {
      return null;
    }
  }

  void dispose() {
    for (final settings in _settings.values) {
      settings?.dispose();
    }
  }
}

class GnomeSettings {
  GnomeSettings(String schemaId, {String? path})
      : _settings = GSettings(schemaId, path: path) {
    _settings.keysChanged.listen((keys) {
      for (final key in keys) {
        _updateValue(key);
      }
    });
  }

  final GSettings _settings;
  final _values = <String, dynamic>{};
  final _listeners = <VoidCallback>{};

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void dispose() => _settings.close();

  bool? boolValue(String key) => getValue<bool>(key);
  int? intValue(String key) => getValue<int>(key);
  double? doubleValue(String key) => getValue<double>(key);
  String? stringValue(String key) => getValue<String>(key);
  Iterable<String>? stringArrayValue(String key) =>
      getValue<Iterable>(key)?.cast<String>();

  T? getValue<T>(String key) => _values[key] ?? _updateValue(key);

  T? _updateValue<T>(String key) {
    T? value;
    _settings.get(key).then((v) {
      value = v.toNative() as T?;
      if (_values[key] != value) {
        _values[key] = value;
        notifyListeners();
      }
    }).catchError((_) {
      value = null;
    });
    return value;
  }

  Future<void> setValue<T>(String key, T value) async {
    if (_values[key] == value) return;
    _values[key] = value;

    return switch (T) {
      const (bool) => _settings.set(key, DBusBoolean(value as bool)),
      const (int) => _settings.set(key, DBusInt32(value as int)),
      const (double) => _settings.set(key, DBusDouble(value as double)),
      const (String) => _settings.set(key, DBusString(value as String)),
      const (List<String>) =>
        _settings.set(key, DBusArray.string(value as List<String>)),
      _ => throw UnsupportedError('Unsupported type: $T'),
    };
  }

  Future<void> setUint32Value(String key, int value) async {
    if (_values[key] == value) return;
    _values[key] = value;
    await _settings.set(key, DBusUint32(value));
  }

  Future<void> resetValue(String key) =>
      _settings.setAll(<String, DBusValue?>{key: null});
}
