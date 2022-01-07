import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

void main() {
  testWidgets(
      '- YaruRow Test when actionWidget && trailingWidget && leadingWidget != null',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: const Scaffold(
        body: YaruRow(
          enabled: true,
          leadingWidget: Text("Foo Leading"),
          actionWidget: Text("Foo Text"),
          trailingWidget: Icon(Icons.add),
          description: "Foo Description",
        ),
      ),
    ));

    final trailingWidgetFinder = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.add,
    );
    expect(find.text("Foo Text"), findsOneWidget);
    expect(find.text("Foo Description"), findsOneWidget);
    expect(find.text("Foo Leading"), findsOneWidget);
    expect(trailingWidgetFinder, findsOneWidget);
  });

  testWidgets('- YaruRow widget when leadingWidget & Description == null',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: const Scaffold(
        body: YaruRow(
          enabled: true,
          leadingWidget: null,
          actionWidget: Text("Foo Text"),
          trailingWidget: Icon(Icons.add),
        ),
      ),
    ));

    final trailingWidgetFinder = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.add,
    );
    expect(find.text("Foo Text"), findsOneWidget);
    expect(find.text("Foo Description"), findsNothing);
    expect(find.text("Foo Leading"), findsNothing);
    expect(trailingWidgetFinder, findsOneWidget);
  });
}
