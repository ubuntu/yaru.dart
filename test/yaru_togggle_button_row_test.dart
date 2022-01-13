import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_toggle_buttons_row.dart';

void main() {
  testWidgets('- YaruToggleButtonsRow Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruToggleButtonsRow(
          actionLabel: "Foo Label",
          onPressed: (int x) {},
          selectedValues: const [false],
          actionDescription: "Foo Description",
          labels: const ["Label"],
        ),
      ),
    ));

    expect(find.text("Foo Label"), findsOneWidget);
    expect(find.text("Foo Description"), findsOneWidget);
    expect(find.byType(ToggleButtons), findsOneWidget);
    expect(find.text("Label"), findsOneWidget);
  });
}
