import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';
import 'package:platform_linux/platform.dart';

abstract class YaruSettings {
  factory YaruSettings({required Platform platform}) = YaruGtkSettings;
  const YaruSettings._();

  String? getThemeName();
  Stream<String?> get themeNameChanged;
}

const _accentColorKey = 'accent-color';

class YaruGtkSettings extends YaruSettings {
  YaruGtkSettings({
    @visibleForTesting GtkSettings? settings,
    required Platform platform,
  })  : _settings = settings ?? GtkSettings(),
        _platform = platform,
        super._();

  final GtkSettings _settings;
  final Platform _platform;

  @override
  String? getThemeName() => _settings.getProperty(kGtkThemeName) as String?;

  @override
  Stream<String?> get themeNameChanged {
    return _settings
        .notifyProperty(
          _platform.operatingSystemVersion == '24.10'
              ? _accentColorKey
              : kGtkThemeName,
        )
        .cast<String?>();
  }
}
