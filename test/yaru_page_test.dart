import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/constants.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  testWidgets('YaruPage Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruPage(
          children: [Container()],
          padding: const EdgeInsets.all(8),
        ),
      ),
    ));

    final paddingFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Padding && widget.padding == const EdgeInsets.all(8),
    );
    expect(paddingFinder, findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('- Default padding will be given if padding is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruPage(
          children: [Container()],
        ),
      ),
    ));

    final paddingFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding == const EdgeInsets.all(kDefaultPagePadding),
    );
    expect(paddingFinder, findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });
}
