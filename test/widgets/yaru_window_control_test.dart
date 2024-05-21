import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('the checkbox react to taps', (tester) async {
    var clicked = false;

    Widget builder() {
      return MaterialApp(
        home: Scaffold(
          body: YaruWindowControl(
            type: YaruWindowControlType.minimize,
            onTap: () {
              clicked = true;
            },
          ),
        ),
      );
    }

    final checkboxFinder = find.byType(YaruWindowControl);

    await tester.pumpWidget(builder());
    await tester.tap(checkboxFinder);
    expect(clicked, isTrue);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      late YaruWindowControlType type;

      if (variant.label.contains('close')) {
        type = YaruWindowControlType.close;
      } else if (variant.label.contains('maximize')) {
        type = YaruWindowControlType.maximize;
      } else if (variant.label.contains('restore')) {
        type = YaruWindowControlType.restore;
      } else if (variant.label.contains('minimize')) {
        type = YaruWindowControlType.minimize;
      }

      late YaruWindowControlPlatform platform;
      late Size size;

      if (variant.label.startsWith('windows')) {
        platform = YaruWindowControlPlatform.windows;
        size = kYaruWindowsWindowControlSize;
      } else {
        platform = YaruWindowControlPlatform.yaru;
        size = const Size.square(kYaruWindowControlSize);
      }

      await tester.pumpScaffold(
        YaruWindowControl(
          type: type,
          platform: platform,
          onTap: variant.hasState(WidgetState.disabled) ? null : () {},
        ),
        themeMode: variant.themeMode,
        size: size,
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruWindowControl));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruWindowControl));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruWindowControl),
        matchesGoldenFile('goldens/yaru_window_control-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  for (final platform in YaruWindowControlPlatform.values)
    for (final type in YaruWindowControlType.values)
      ...() {
        final platformPrefix =
            platform == YaruWindowControlPlatform.windows ? 'windows-' : '';
        return {
          ...goldenThemeVariants(
            '$platformPrefix${type.name}',
            <WidgetState>{},
          ),
          ...goldenThemeVariants(
            '$platformPrefix${type.name}-disabled',
            {WidgetState.disabled},
          ),
          ...goldenThemeVariants(
            '$platformPrefix${type.name}-hovered',
            {WidgetState.hovered},
          ),
          ...goldenThemeVariants(
            '$platformPrefix${type.name}-pressed',
            {WidgetState.pressed},
          ),
        };
      }(),
});
