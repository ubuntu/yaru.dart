import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  testWidgets('YaruCheckboxRow Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruCheckboxRow(
          onChanged: (valeu) {},
          enabled: true,
          text: "Check Box",
          value: true,
        ),
      ),
    ));

    /// The [byWidgetPredicate] method of the [CommonFinders] class is to specify the
    /// type of any widget and so examine the state of that type.
    final finder = find.byWidgetPredicate(
      (widget) => widget is Checkbox && widget.value == true,
      description: "Check Box is checked",
    );
    final sizedBoxFinder = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == null,
      description: "Sized box having width as null",
    );
    final textFinder = find.text("Check Box");

    expect(textFinder, findsOneWidget);
    expect(finder, findsOneWidget);
    expect(sizedBoxFinder, findsNothing);
  });
}
