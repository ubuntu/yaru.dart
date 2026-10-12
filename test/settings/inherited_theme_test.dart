import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/testing.dart';
import 'package:yaru/settings.dart';
import 'package:yaru/theme.dart';

const _childKey = Key('child');

class _FakeYaruSettings implements YaruSettings {
  _FakeYaruSettings({this.themeName});

  final String? themeName;

  @override
  String? getAccentColor() => null;

  @override
  bool? getStatusShapes() => null;

  @override
  String? getThemeName() => themeName;

  @override
  Stream<String?> get accentColorChanged => const Stream.empty();

  @override
  Stream<bool?> get statusShapesChanged => const Stream.empty();

  @override
  Stream<String?> get themeNameChanged => const Stream.empty();

  @override
  void init() {}

  @override
  Future<void> dispose() async {}
}

Platform _linuxPlatform(Map<String, String> environment) =>
    TestPlatform.native(operatingSystem: 'linux', environment: environment);

/// Pumps a [YaruTheme] with an injected [platform] and GTK [themeName],
/// and returns the resolved [YaruThemeData].
Future<YaruThemeData> _pumpYaruTheme(
  WidgetTester tester, {
  required Platform platform,
  required String themeName,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: YaruTheme(
        platform: platform,
        settings: _FakeYaruSettings(themeName: themeName),
        child: const SizedBox(key: _childKey),
      ),
    ),
  );
  return YaruTheme.of(tester.element(find.byKey(_childKey)));
}

void main() {
  group('fallback variant', () {
    const cases = <String, YaruVariant>{
      'Budgie': YaruVariant.ubuntuBudgieBlue,
      'X-Cinnamon': YaruVariant.ubuntuCinnamonBrown,
      'ubuntu:GNOME': YaruVariant.orange,
      'KDE': YaruVariant.kubuntuBlue,
      'LXQt': YaruVariant.lubuntuBlue,
      'MATE': YaruVariant.ubuntuMateGreen,
      'Unity': YaruVariant.ubuntuUnityPurple,
      'XFCE': YaruVariant.xubuntuBlue,
    };

    for (final MapEntry(key: desktop, value: variant) in cases.entries) {
      testWidgets('resolves $variant from XDG_CURRENT_DESKTOP=$desktop', (
        tester,
      ) async {
        final data = await _pumpYaruTheme(
          tester,
          platform: _linuxPlatform({'XDG_CURRENT_DESKTOP': desktop}),
          // Not one of the built-in Yaru/Adwaita theme name mappings.
          themeName: 'Breeze',
        );
        expect(data.variant, variant);
      });
    }

    testWidgets('prefers ORIGINAL_XDG_CURRENT_DESKTOP', (tester) async {
      final data = await _pumpYaruTheme(
        tester,
        platform: _linuxPlatform({
          'ORIGINAL_XDG_CURRENT_DESKTOP': 'KDE',
          'XDG_CURRENT_DESKTOP': 'ubuntu:GNOME',
        }),
        themeName: 'Breeze',
      );
      expect(data.variant, YaruVariant.kubuntuBlue);
    });

    testWidgets('keeps the desktop precedence order', (tester) async {
      final data = await _pumpYaruTheme(
        tester,
        platform: _linuxPlatform({'XDG_CURRENT_DESKTOP': 'Budgie:GNOME'}),
        themeName: 'Breeze',
      );
      expect(data.variant, YaruVariant.ubuntuBudgieBlue);
    });

    testWidgets('resolves no variant for an unknown desktop', (tester) async {
      final data = await _pumpYaruTheme(
        tester,
        platform: _linuxPlatform({'XDG_CURRENT_DESKTOP': 'sway'}),
        themeName: 'Breeze',
      );
      expect(data.variant, isNull);
    });

    testWidgets('resolves no variant without a native platform', (
      tester,
    ) async {
      final data = await _pumpYaruTheme(
        tester,
        platform: const TestPlatform.unknown(),
        themeName: 'Breeze',
      );
      expect(data.variant, isNull);
    });
  });
}
