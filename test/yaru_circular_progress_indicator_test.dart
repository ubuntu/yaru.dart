import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_progress_indicator.dart';

void main() {
  testWidgets('- YaruCircularProgressIndicator Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: YaruCircularProgressIndicator(
          value: 0.5,
          color: Colors.redAccent,
          semanticsLabel: "Semantic Label",
          semanticsValue: "Semantic Value",
        ),
      ),
    ));

    final linearProgressIndicatorFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator && widget.value == 0.5,
    );
    final semanticValueFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator &&
          widget.semanticsValue == "Semantic Value",
    );
    final semanticLabelFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator &&
          widget.semanticsLabel == "Semantic Label",
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(linearProgressIndicatorFinder, findsOneWidget);
    expect(semanticLabelFinder, findsOneWidget);
    expect(semanticValueFinder, findsOneWidget);
  });
}
