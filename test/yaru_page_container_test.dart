import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_option_button.dart';
import 'package:yaru_widgets/src/yaru_page_container.dart';

void main() {
  testWidgets('- YaruPageContainer Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruPageContainer(
          child: Container(),
          width: 100,
        ),
      ),
    ));

    // When `width` is 100 the [SizedBox] width will be 116
    final sixedBoxFinder = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 116,
    );
    expect(find.byType(Container), findsOneWidget);
    expect(sixedBoxFinder, findsOneWidget);
  });

  testWidgets('- SizedBox width is 516 when width passed is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruPageContainer(
          child: Container(),
        ),
      ),
    ));

    // When `width` is null the [SizedBox] width will be 516
    final sixedBoxFinder = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 516,
    );
    expect(find.byType(Container), findsOneWidget);
    expect(sixedBoxFinder, findsOneWidget);
  });
}
