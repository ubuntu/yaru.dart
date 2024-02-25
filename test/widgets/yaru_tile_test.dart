import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/src/widgets/yaru_tile.dart';

void main() {
  testWidgets('ltr layout', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: YaruTile(
            leading: Text('Leading'),
            title: Text('Title'),
            subtitle: Text('Subtitle'),
            trailing: Text('Trailing'),
          ),
        ),
      ),
    );

    final leading = find.text('Leading');
    expect(leading, findsOneWidget);

    final title = find.text('Title');
    expect(title, findsOneWidget);

    final subtitle = find.text('Subtitle');
    expect(subtitle, findsOneWidget);

    final trailing = find.text('Trailing');
    expect(trailing, findsOneWidget);

    expect(
      tester.getRect(leading).right,
      lessThan(tester.getRect(title).left),
    );
    expect(
      tester.getRect(title).left,
      equals(tester.getRect(subtitle).left),
    );
    expect(
      tester.getRect(subtitle).top,
      greaterThan(tester.getRect(title).bottom),
    );
    expect(
      tester.getRect(trailing).left,
      greaterThan(tester.getRect(title).right),
    );
  });

  testWidgets('rtl layout', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: YaruTile(
              leading: Text('Leading'),
              title: Text('Title'),
              subtitle: Text('Subtitle'),
              trailing: Text('Trailing'),
            ),
          ),
        ),
      ),
    );

    final leading = find.text('Leading');
    expect(leading, findsOneWidget);

    final title = find.text('Title');
    expect(title, findsOneWidget);

    final subtitle = find.text('Subtitle');
    expect(subtitle, findsOneWidget);

    final trailing = find.text('Trailing');
    expect(trailing, findsOneWidget);

    expect(
      tester.getRect(leading).left,
      greaterThan(tester.getRect(title).right),
    );
    expect(
      tester.getRect(title).right,
      equals(tester.getRect(subtitle).right),
    );
    expect(
      tester.getRect(subtitle).top,
      greaterThan(tester.getRect(title).bottom),
    );
    expect(
      tester.getRect(trailing).right,
      lessThan(tester.getRect(title).left),
    );
  });
}
