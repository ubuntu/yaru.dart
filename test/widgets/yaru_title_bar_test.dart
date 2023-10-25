import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
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
        expect(titleBar.windowControlLayout?.leftItems ?? [], isEmpty);
        expect(titleBar.windowControlLayout?.rightItems ?? [], isEmpty);
      } else {
        expect(
          titleBar.windowControlLayout?.rightItems
                  .contains(YaruWindowControlType.close) ??
              false,
          isTrue,
        );
        expect(
          (titleBar.windowControlLayout?.rightItems
                      .contains(YaruWindowControlType.maximize) ??
                  false) ||
              (titleBar.windowControlLayout?.rightItems
                      .contains(YaruWindowControlType.restore) ??
                  false),
          isTrue,
        );
        expect(
          titleBar.windowControlLayout?.rightItems
                  .contains(YaruWindowControlType.minimize) ??
              false,
          isTrue,
        );
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
              windowControlLayout: YaruWindowControlLayout([], []),
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

      expect(titleBar.windowControlLayout?.leftItems, isEmpty);
      expect(titleBar.windowControlLayout?.rightItems, isEmpty);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      final state = variant.value!.first as YaruWindowState;
      final windowControlLayout =
          variant.value!.last as YaruWindowControlLayout;
      final builder = variant.label.contains('dialog')
          ? YaruDialogTitleBar.new
          : YaruTitleBar.new;

      await tester.pumpScaffold(
        builder(
          isActive: state.isActive,
          isMaximized: state.isMaximized,
          windowControlLayout: windowControlLayout,
          isDraggable: false,
          title: Text(state.title!),
          onClose: (_) {},
          onMaximize: (_) {},
          onMinimize: (_) {},
          onRestore: (_) {},
          backgroundColor: variant.label.contains('red') ? Colors.red : null,
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
  ...goldenThemeVariants(
    'empty',
    [
      const YaruWindowState(
        isActive: true,
        title: 'empty',
      ),
      const YaruWindowControlLayout([], [])
    ],
  ),
  ...goldenThemeVariants(
    'closable',
    [
      const YaruWindowState(
        isActive: true,
        title: 'closable',
      ),
      const YaruWindowControlLayout([], [YaruWindowControlType.close])
    ],
  ),
  ...goldenThemeVariants(
    'maximizable',
    [
      const YaruWindowState(
        isActive: true,
        isMaximized: false,
        title: 'maximizable',
      ),
      const YaruWindowControlLayout([], [
        YaruWindowControlType.minimize,
        YaruWindowControlType.maximize,
        YaruWindowControlType.close
      ])
    ],
  ),
  ...goldenThemeVariants('restorable', [
    const YaruWindowState(
      isActive: true,
      isMaximized: true,
      title: 'restorable',
    ),
    const YaruWindowControlLayout([], [
      YaruWindowControlType.minimize,
      YaruWindowControlType.maximize,
      YaruWindowControlType.close
    ])
  ]),
  ...goldenThemeVariants('inactive', [
    const YaruWindowState(
      isActive: false,
      title: 'inactive',
    ),
    const YaruWindowControlLayout([], [
      YaruWindowControlType.minimize,
      YaruWindowControlType.maximize,
      YaruWindowControlType.close
    ])
  ]),
  ...goldenThemeVariants('dialog', [
    const YaruWindowState(
      isActive: true,
      title: 'dialog',
    ),
    const YaruWindowControlLayout([], [YaruWindowControlType.close])
  ]),
  ...goldenThemeVariants('dialog-red', [
    const YaruWindowState(
      isActive: true,
      title: 'red dialog',
    ),
    const YaruWindowControlLayout([], [YaruWindowControlType.close])
  ]),
});
