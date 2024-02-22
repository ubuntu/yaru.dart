import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      final controller = ScrollController(initialScrollOffset: 72);

      await tester.pumpScaffold(
        Padding(
          padding: const EdgeInsets.all(10),
          child: YaruBorderContainer(
            color: variant.value!['color'],
            border: variant.value!['border'],
            borderRadius: variant.value!['borderRadius'],
            margin: variant.value!['margin'] ?? EdgeInsets.zero,
            padding: variant.value!['padding'] ?? EdgeInsets.zero,
            clipBehavior: variant.value!['clipBehavior'] ?? Clip.none,
            child: ListView.builder(
              controller: controller,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(YaruIcons.star_filled),
                title: Text('Tile $index'),
                onTap: () {},
              ),
            ),
          ),
        ),
        themeMode: variant.themeMode,
        size: const Size(200, 200),
      );
      await tester.pumpAndSettle();

      await tester.down(find.text('Tile 1'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruBorderContainer),
        matchesGoldenFile('goldens/yaru_border_container-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('default', <String, dynamic>{}),
  ...goldenThemeVariants('clip', {
    'clipBehavior': Clip.antiAlias,
  }),
  ...goldenThemeVariants('padding', {
    'padding': const EdgeInsets.all(10),
  }),
  ...goldenThemeVariants('padding-clip', {
    'padding': const EdgeInsets.all(10),
    'clipBehavior': Clip.antiAlias,
  }),
  ...goldenThemeVariants('margin', {
    'margin': const EdgeInsets.all(10),
  }),
  ...goldenThemeVariants('margin-clip', {
    'margin': const EdgeInsets.all(10),
    'clipBehavior': Clip.antiAlias,
  }),
  ...goldenThemeVariants('padding-margin', {
    'padding': const EdgeInsets.all(10),
    'margin': const EdgeInsets.all(10),
  }),
  ...goldenThemeVariants('padding-margin-clip', {
    'padding': const EdgeInsets.all(10),
    'margin': const EdgeInsets.all(10),
    'clipBehavior': Clip.antiAlias,
  }),
  ...goldenThemeVariants('custom', {
    'color': Colors.blue,
    'border': Border.all(color: Colors.red, width: 2),
    'borderRadius': BorderRadius.circular(20),
    'clipBehavior': Clip.antiAlias,
  }),
});
