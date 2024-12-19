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
  String? getButtonLayout();
  Stream<String?> get themeNameChanged;
  Stream<String?> get accentColorChanged;
  Stream<String?> get buttonLayoutChanged;
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
  GnomeSettings? _interfaceSettings;
  GnomeSettings? _wmPrefSettings;

  @override
  String? getThemeName() => _gtkSettings.getProperty(kGtkThemeName) as String?;

  @override
  Stream<String?> get themeNameChanged =>
      _gtkSettings.notifyProperty(kGtkThemeName).cast<String?>();

  final _accentColorController = StreamController<String?>.broadcast();
  @override
  Stream<String?> get accentColorChanged => _accentColorController.stream;

  final _buttonLayoutController = StreamController<String?>.broadcast();
  @override
  Stream<String?> get buttonLayoutChanged => _buttonLayoutController.stream;

  @override
  void init() {
    _interfaceSettings ??= _gSettingsService.lookup(kSchemaInterface);
    _interfaceSettings?.addListener(
      () => _accentColorController.add(getAccentColor()),
    );
    _wmPrefSettings ??= _gSettingsService.lookup(kSchemeWmPreferences);
    _wmPrefSettings?.addListener(
      () => _buttonLayoutController.add(getButtonLayout()),
    );
  }

  @override
  Future<void> dispose() async {
    await _accentColorController.close();
    await _buttonLayoutController.close();
    await _gSettingsService.dispose();
  }

  @override
  String? getAccentColor() => _interfaceSettings?.stringValue(kAccentColorKey);

  @override
  String? getButtonLayout() {
    final layout = _wmPrefSettings?.stringValue(kButtonLayoutKey);
    return (layout == null || layout == 'appmenu:close')
        ? _defaultLayout
        : layout;
  }
}

const _defaultLayout = ':minimize,maximize,close';
