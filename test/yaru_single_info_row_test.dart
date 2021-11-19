import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_single_info_row.dart';

void main() {
  testWidgets('- YaruSingleInfoRow Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: YaruSingleInfoRow(
          infoLabel: "Foo Label",
          infoValue: "Foo Value",
        ),
      ),
    ));

    // Use [widget] if you only expect to match one widget.
    // Throws a [StateError] if finder is empty or matches more than one widget.

    final findAlign =
        (tester.widget(find.byType(SelectableText)) as SelectableText)
            .textAlign;

    expect(find.text("Foo Label"), findsOneWidget);
    expect(find.text("Foo Value"), findsOneWidget);
    expect(findAlign, TextAlign.right);
  });
}
