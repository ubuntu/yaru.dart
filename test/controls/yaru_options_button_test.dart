import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/controls/yaru_option_button.dart';

void main() {
  testWidgets('with icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruOptionButton(
            onPressed: () {},
            child: const Icon(Icons.flutter_dash),
          ),
        ),
      ),
    );

    expect(
      find.widgetWithIcon(YaruOptionButton, Icons.flutter_dash),
      findsOneWidget,
    );
  });

  testWidgets('with color disk', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruOptionButton.color(
            onPressed: () {},
            color: Colors.red,
          ),
        ),
      ),
    );

    final box = find.descendant(
      of: find.byType(YaruOptionButton),
      matching: find.byType(DecoratedBox),
    );
    expect(box, findsOneWidget);
    expect(
      tester.widget<DecoratedBox>(box).decoration,
      isA<BoxDecoration>().having((d) => d.color, 'color', Colors.red),
    );
  });
}
