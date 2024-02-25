import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_window_platform_interface/yaru_window_platform_interface.dart';

import '../yaru_golden_tester.dart';

class MockYaruWindowPlatform
    with Mock, MockPlatformInterfaceMixin
    implements YaruWindowPlatform {}

void main() {
  testWidgets(
    'window state',
    (tester) async {
      const state = YaruWindowState(
        isClosable: true,
        isMaximizable: true,
        isMinimizable: true,
        isRestorable: true,
      );

      final window = MockYaruWindowPlatform();
      when(() => window.state(0)).thenAnswer((_) async => state);
      when(() => window.states(0)).thenAnswer((_) => Stream.value(state));
      YaruWindowPlatform.instance = window;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: YaruWindowTitleBar(),
          ),
        ),
      );
      await untilCalled(() => window.states(0));
      await tester.pump();

      expect(find.byType(YaruTitleBar), findsOneWidget);
      final titleBar = tester.widget<YaruTitleBar>(
        find.byType(YaruTitleBar),
      );

      if (defaultTargetPlatform == TargetPlatform.macOS) {
        expect(titleBar.isClosable, isFalse);
        expect(titleBar.isMaximizable, isFalse);
        expect(titleBar.isMinimizable, isFalse);
        expect(titleBar.isRestorable, isFalse);
      } else {
        expect(titleBar.isClosable, isTrue);
        expect(titleBar.isMaximizable, isTrue);
        expect(titleBar.isMinimizable, isTrue);
        expect(titleBar.isRestorable, isTrue);
      }
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'explicit state',
    (tester) async {
      const state = YaruWindowState(
        isClosable: true,
        isMaximizable: true,
        isMinimizable: true,
        isRestorable: true,
      );

      final window = MockYaruWindowPlatform();
      when(() => window.state(0)).thenAnswer((_) async => state);
      when(() => window.states(0)).thenAnswer((_) => Stream.value(state));
      YaruWindowPlatform.instance = window;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: YaruWindowTitleBar(
              isClosable: false,
              isMinimizable: false,
              isMaximizable: false,
              isRestorable: false,
            ),
          ),
        ),
      );
      await untilCalled(() => window.states(0));
      await tester.pump();

      expect(find.byType(YaruTitleBar), findsOneWidget);
      final titleBar = tester.widget<YaruTitleBar>(
        find.byType(YaruTitleBar),
      );

      expect(titleBar.isClosable, isFalse);
      expect(titleBar.isMaximizable, isFalse);
      expect(titleBar.isMinimizable, isFalse);
      expect(titleBar.isRestorable, isFalse);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      late YaruWindowControlPlatform platform;

      if (variant.label.startsWith('windows')) {
        platform = YaruWindowControlPlatform.windows;
      } else {
        platform = YaruWindowControlPlatform.yaru;
      }

      final state = variant.value!;
      final builder = variant.label.contains('dialog')
          ? YaruDialogTitleBar.new
          : YaruTitleBar.new;

      await tester.pumpScaffold(
        builder(
          isActive: state.isActive,
          isClosable: state.isClosable,
          isDraggable: false,
          isMaximizable: state.isMaximizable,
          isMinimizable: state.isMinimizable,
          isRestorable: state.isRestorable,
          title: Text(state.title!),
          onClose: (_) {},
          onMaximize: (_) {},
          onMinimize: (_) {},
          onRestore: (_) {},
          backgroundColor: variant.label.contains('red') ? Colors.red : null,
          platform: platform,
        ),
        themeMode: variant.themeMode,
        size: const Size(480, kYaruTitleBarHeight),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruTitleBar),
        matchesGoldenFile('goldens/yaru_title_bar-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  for (final platform in YaruWindowControlPlatform.values)
    ...() {
      final platformPrefix =
          platform == YaruWindowControlPlatform.windows ? 'windows-' : '';
      return {
        ...goldenThemeVariants(
          '${platformPrefix}empty',
          const YaruWindowState(
            isActive: true,
            title: 'empty',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}closable',
          const YaruWindowState(
            isActive: true,
            isClosable: true,
            title: 'closable',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}maximizable',
          const YaruWindowState(
            isActive: true,
            isMinimizable: true,
            isMaximizable: true,
            isClosable: true,
            title: 'maximizable',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}restorable',
          const YaruWindowState(
            isActive: true,
            isMinimizable: true,
            isRestorable: true,
            isClosable: true,
            title: 'restorable',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}inactive',
          const YaruWindowState(
            isActive: false,
            isMinimizable: true,
            isMaximizable: true,
            isClosable: true,
            title: 'inactive',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}dialog',
          const YaruWindowState(
            isActive: true,
            isMinimizable: false,
            isMaximizable: false,
            isRestorable: false,
            isClosable: true,
            title: 'dialog',
          ),
        ),
        ...goldenThemeVariants(
          '${platformPrefix}dialog-red',
          const YaruWindowState(
            isActive: true,
            isClosable: true,
            isMinimizable: false,
            isMaximizable: false,
            isRestorable: false,
            title: 'red dialog',
          ),
        ),
      };
    }(),
});
