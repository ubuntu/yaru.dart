import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/controls/yaru_window.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

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
    const YaruWindowState(
      isActive: true,
      title: 'empty',
    ),
  ),
  ...goldenThemeVariants(
    'closable',
    const YaruWindowState(
      isActive: true,
      isClosable: true,
      title: 'closable',
    ),
  ),
  ...goldenThemeVariants(
    'maximizable',
    const YaruWindowState(
      isActive: true,
      isMinimizable: true,
      isMaximizable: true,
      isClosable: true,
      title: 'maximizable',
    ),
  ),
  ...goldenThemeVariants(
    'restorable',
    const YaruWindowState(
      isActive: true,
      isMinimizable: true,
      isRestorable: true,
      isClosable: true,
      title: 'restorable',
    ),
  ),
  ...goldenThemeVariants(
    'inactive',
    const YaruWindowState(
      isActive: false,
      isMinimizable: true,
      isMaximizable: true,
      isClosable: true,
      title: 'inactive',
    ),
  ),
  ...goldenThemeVariants(
    'dialog',
    const YaruWindowState(
      isActive: true,
      isMinimizable: false,
      isMaximizable: false,
      isClosable: true,
      title: 'dialog',
    ),
  ),
  ...goldenThemeVariants(
    'dialog-red',
    const YaruWindowState(
      isActive: true,
      isClosable: true,
      isMinimizable: false,
      isMaximizable: false,
      title: 'red dialog',
    ),
  ),
});
