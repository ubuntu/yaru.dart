import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';
import 'package:yaru/src/theme_widgets/gtk_constants.dart';
import 'package:yaru/src/theme_widgets/settings_service.dart';

abstract class YaruSettings {
  factory YaruSettings() = YaruGtkSettings;
  const YaruSettings._();

  String? getThemeName();
  Stream<String?> get themeNameChanged;
  void dispose();
}

class YaruGtkSettings extends YaruSettings {
  YaruGtkSettings([
    @visibleForTesting GtkSettings? settings,
    @visibleForTesting GSettingsService? settingsService,
  ])  : _settings = settings ?? GtkSettings(),
        _gSettingsService = settingsService ?? GSettingsService(),
        super._();

  final GtkSettings _settings;
  final GSettingsService _gSettingsService;

  @override
  String? getThemeName() =>
      _gSettingsService
          .lookup(kSchemaInterface)
          ?.stringValue(kAccentColorKey) ??
      _settings.getProperty(kGtkThemeName) as String?;

  @override
  Stream<String?> get themeNameChanged =>
      _settings.notifyProperty(kGtkThemeName).cast<String?>();

  @override
  void dispose() => _gSettingsService.dispose();
}
