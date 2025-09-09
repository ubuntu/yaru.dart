import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';
import 'package:yaru/src/settings/gtk_constants.dart';
import 'package:yaru/src/settings/settings_service.dart';

abstract class YaruSettings {
  factory YaruSettings() = YaruGtkSettings;
  const YaruSettings._();

  String? getThemeName();
  String? getAccentColor();
  bool? getStatusShapes();
  Stream<String?> get themeNameChanged;
  Stream<String?> get accentColorChanged;
  Stream<bool?> get statusShapesChanged;
  void init();
  Future<void> dispose();
}

class YaruGtkSettings extends YaruSettings {
  YaruGtkSettings([
    @visibleForTesting GtkSettings? settings,
    @visibleForTesting GSettingsService? settingsService,
  ]) : _gtkSettings = settings ?? GtkSettings(),
       _gSettingsService = settingsService ?? GSettingsService(),
       super._();

  final GtkSettings _gtkSettings;
  final GSettingsService _gSettingsService;
  GnomeSettings? _gSettings;
  GnomeSettings? _gA11ySettings;

  @override
  String? getThemeName() => _gtkSettings.getProperty(kGtkThemeName) as String?;

  @override
  Stream<String?> get themeNameChanged =>
      _gtkSettings.notifyProperty(kGtkThemeName).cast<String?>();

  final _accentColorController = StreamController<String?>.broadcast();
  @override
  Stream<String?> get accentColorChanged => _accentColorController.stream;

  final _statusShapesController = StreamController<bool?>.broadcast();
  @override
  Stream<bool?> get statusShapesChanged => _statusShapesController.stream;

  @override
  void init() {
    _gSettings ??= _gSettingsService.lookup(kSchemaInterface);
    _gSettings?.addListener(() => _accentColorController.add(getAccentColor()));

    _gA11ySettings ??= _gSettingsService.lookup(kA11ySchemaInterface);
    _gA11ySettings?.addListener(
      () => _statusShapesController.add(getStatusShapes()),
    );
  }

  @override
  Future<void> dispose() async {
    await _accentColorController.close();
    await _gSettingsService.dispose();
  }

  @override
  String? getAccentColor() => _gSettings?.stringValue(kAccentColorKey);

  @override
  bool? getStatusShapes() => _gA11ySettings?.boolValue(kStatusShapesKey);
}
