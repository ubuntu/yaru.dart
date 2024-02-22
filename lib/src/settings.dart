import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';

abstract class YaruSettings {
  factory YaruSettings() = YaruGtkSettings;
  const YaruSettings._();

  String? getThemeName();
  Stream<String?> get themeNameChanged;
}

class YaruGtkSettings extends YaruSettings {
  YaruGtkSettings([@visibleForTesting GtkSettings? settings])
      : _settings = settings ?? GtkSettings(),
        super._();

  final GtkSettings _settings;

  @override
  String? getThemeName() {
    return _settings.getProperty(kGtkThemeName) as String?;
  }

  @override
  Stream<String?> get themeNameChanged {
    return _settings.notifyProperty(kGtkThemeName).cast<String?>();
  }
}
