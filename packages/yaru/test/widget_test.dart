import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru/src/settings.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([YaruSettings])
void main() {
  testWidgets('variant', (tester) async {
    await tester.pumpTheme(variant: YaruVariant.blue);
    final context = tester.element(find.byType(Container));
    expect(YaruTheme.of(context).variant, YaruVariant.blue);
  });

  testWidgets('flutter test', (tester) async {
    await tester.pumpTheme(environment: {'FLUTTER_TEST': '1'});
    final context = tester.element(find.byType(Container));
    expect(YaruTheme.of(context).variant, isNull);
  });

  group('gtk-theme', () {
    testWidgets('unknown', (tester) async {
      final settings = createMockSettings(theme: '');
      await tester.pumpTheme(settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, null);
    });

    testWidgets('yaru', (tester) async {
      final settings = createMockSettings(theme: 'Yaru');
      await tester.pumpTheme(settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.orange);
    });

    testWidgets('dark', (tester) async {
      final settings = createMockSettings(theme: 'Yaru-dark');
      await tester.pumpTheme(settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.orange);
    });

    testWidgets('color', (tester) async {
      final settings = createMockSettings(theme: 'Yaru-blue');
      await tester.pumpTheme(settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.blue);
    });

    testWidgets('change', (tester) async {
      final settings = createMockSettings(theme: 'Yaru-blue');
      final themeNameChanged = StreamController<String>(sync: true);
      addTearDown(themeNameChanged.close);
      when(settings.themeNameChanged)
          .thenAnswer((_) => themeNameChanged.stream);

      await tester.pumpTheme(settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.blue);

      themeNameChanged.add('Yaru-red');
      await tester.pump();
      expect(YaruTheme.of(context).variant, YaruVariant.red);
    });
  });

  group('desktop', () {
    testWidgets('unknown', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'unknown', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, isNull);
    });

    testWidgets('budgie', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'budgie-desktop', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.ubuntuBudgieBlue);
    });

    testWidgets('cinnamon', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'X-Cinnamon', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.ubuntuCinnamonBrown);
    });

    testWidgets('ubuntu', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'GNOME:ubuntu', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.orange);
    });

    testWidgets('kde', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'KDE', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.kubuntuBlue);
    });

    testWidgets('lubuntu', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'LXQt', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.lubuntuBlue);
    });

    testWidgets('mate', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'MATE', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.ubuntuMateGreen);
    });

    testWidgets('unity', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'Unity', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.ubuntuUnityPurple);
    });

    testWidgets('xubuntu', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(desktop: 'XFCE', settings: settings);
      await untilCalled(settings.getThemeName());
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).variant, YaruVariant.xubuntuBlue);
    });
  });

  group('high contrast', () {
    testWidgets('on', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(highContrast: true, settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).highContrast, isTrue);
    });

    testWidgets('off', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(highContrast: false, settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).highContrast, isFalse);
    });
  });

  group('theme mode', () {
    testWidgets('light', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(themeMode: ThemeMode.light, settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).themeMode, ThemeMode.light);
    });

    testWidgets('dark', (tester) async {
      final settings = createMockSettings();
      await tester.pumpTheme(themeMode: ThemeMode.dark, settings: settings);
      final context = tester.element(find.byType(Container));
      expect(YaruTheme.of(context).themeMode, ThemeMode.dark);
    });
  });

  testWidgets('theme data overrides', (tester) async {
    final settings = createMockSettings();
    const extensions = <ThemeExtension>[];
    const pageTransitionsTheme = PageTransitionsTheme();
    const visualDensity = VisualDensity(horizontal: -4, vertical: -4);
    await tester.pumpTheme(
      extensions: extensions,
      pageTransitionsTheme: pageTransitionsTheme,
      useMaterial3: false,
      visualDensity: visualDensity,
      settings: settings,
    );
    final context = tester.element(find.byType(Container));
    final theme = YaruTheme.of(context);
    expect(theme.extensions, same(extensions));
    expect(theme.pageTransitionsTheme, same(pageTransitionsTheme));
    expect(theme.useMaterial3, isFalse);
    expect(theme.visualDensity, visualDensity);
  });
}

MockYaruSettings createMockSettings({String theme = ''}) {
  final settings = MockYaruSettings();
  when(settings.themeNameChanged).thenAnswer((_) => const Stream.empty());
  when(settings.getThemeName()).thenReturn(theme);
  return settings;
}

extension ThemeTester on WidgetTester {
  Future<void> pumpTheme({
    YaruVariant? variant,
    bool? highContrast,
    ThemeMode? themeMode,
    Iterable<ThemeExtension<dynamic>>? extensions,
    PageTransitionsTheme? pageTransitionsTheme,
    bool? useMaterial3,
    VisualDensity? visualDensity,
    String desktop = '',
    YaruSettings? settings,
    Map<String, String>? environment,
  }) async {
    final data = YaruThemeData(
      variant: variant,
      highContrast: highContrast,
      themeMode: themeMode,
      extensions: extensions,
      pageTransitionsTheme: pageTransitionsTheme,
      useMaterial3: useMaterial3,
      visualDensity: visualDensity,
    );
    await pumpWidget(
      MaterialApp(
        key: ValueKey(data),
        home: YaruTheme(
          data: data,
          platform: FakePlatform(
            operatingSystem: Platform.linux,
            environment: {
              'XDG_CURRENT_DESKTOP': desktop,
              ...?environment,
            },
          ),
          settings: settings,
          child: Container(),
        ),
      ),
    );
    return pump();
  }
}
