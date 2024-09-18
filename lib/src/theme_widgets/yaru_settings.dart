import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';
import 'package:yaru/src/theme_widgets/gtk_constants.dart';
import 'package:yaru/src/theme_widgets/settings_service.dart';

abstract class YaruSettings {
  factory YaruSettings() = YaruGtkSettings;
  const YaruSettings._();

  String? getThemeName();
  String? getAccentColor();
  Stream<String?> get themeNameChanged;
  Stream<String?> get accentColorChanged;
  void init();
  Future<void> dispose();
}

class YaruGtkSettings extends YaruSettings {
  YaruGtkSettings([
    @visibleForTesting GtkSettings? settings,
    @visibleForTesting GSettingsService? settingsService,
  ])  : _gtkSettings = settings ?? GtkSettings(),
        _gSettingsService = settingsService ?? GSettingsService(),
        super._();

  final GtkSettings _gtkSettings;
  final GSettingsService _gSettingsService;
  GnomeSettings? _gSettings;

  @override
  String? getThemeName() => _gtkSettings.getProperty(kGtkThemeName) as String?;

  @override
  Stream<String?> get themeNameChanged =>
      _gtkSettings.notifyProperty(kGtkThemeName).cast<String?>();

  final _accentColorController = StreamController<String?>.broadcast();
  @override
  Stream<String?> get accentColorChanged => _accentColorController.stream;

  @override
  void init() {
    _gSettings ??= _gSettingsService.lookup(kSchemaInterface);
    _gSettings?.addListener(
      () => _accentColorController.add(getAccentColor()),
    );
  }

  @override
  Future<void> dispose() async {
    await _accentColorController.close();
    _gSettingsService.dispose();
  }

  @override
  String? getAccentColor() => _gSettings?.stringValue(kAccentColorKey);
}
