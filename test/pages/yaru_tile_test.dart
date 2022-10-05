import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/pages/yaru_tile.dart';

void main() {
  testWidgets(
      '- YaruTile Test when actionWidget && trailingWidget && leadingWidget != null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: const Scaffold(
          body: YaruTile(
            leading: Text('Foo Leading'),
            trailing: Text('Foo Text'),
            title: Icon(Icons.add),
            subtitle: Text('Foo Description'),
          ),
        ),
      ),
    );

    final trailingWidgetFinder = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.add,
    );
    expect(find.text('Foo Text'), findsOneWidget);
    expect(find.text('Foo Description'), findsOneWidget);
    expect(find.text('Foo Leading'), findsOneWidget);
    expect(trailingWidgetFinder, findsOneWidget);
  });

  testWidgets('- YaruTile widget when leadingWidget & Description == null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: const Scaffold(
          body: YaruTile(
            leading: null,
            trailing: Text('Foo Text'),
            title: Icon(Icons.add),
          ),
        ),
      ),
    );

    final trailingWidgetFinder = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.add,
    );
    expect(find.text('Foo Text'), findsOneWidget);
    expect(find.text('Foo Description'), findsNothing);
    expect(find.text('Foo Leading'), findsNothing);
    expect(trailingWidgetFinder, findsOneWidget);
  });
}
