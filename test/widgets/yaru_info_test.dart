import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('info box', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: YaruInfoBox(
            yaruInfoType: YaruInfoType.success,
            title: Text('YaruInfoBox'),
            subtitle: Text('YaruInfoBox subtitle'),
          ),
        ),
      ),
    );

    final icon = find.widgetWithIcon(Column, YaruInfoType.success.iconData);
    expect(icon, findsOneWidget);

    final title = find.text('YaruInfoBox');
    expect(title, findsOneWidget);

    final subtitle = find.text('YaruInfoBox subtitle');
    expect(subtitle, findsOneWidget);

    expect(tester.getRect(icon).right, lessThan(tester.getRect(title).left));
    expect(tester.getRect(icon).right, lessThan(tester.getRect(subtitle).left));
    expect(tester.getRect(title).left, equals(tester.getRect(subtitle).left));
    expect(
      tester.getRect(subtitle).top,
      lessThanOrEqualTo(tester.getRect(title).bottom),
    );
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpScaffold(
        YaruInfoBox(
          yaruInfoType: variant.value!,
          title: const Text('YaruInfoBox'),
          subtitle: const Text('YaruInfoBox subtitle'),
        ),
        themeMode: variant.themeMode,
        size: const Size(200, 150),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruInfoBox),
        matchesGoldenFile('goldens/yaru_info-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...YaruInfoType.values
      .map((t) => goldenThemeVariants('${t.name}', t))
      .flattened,
});
