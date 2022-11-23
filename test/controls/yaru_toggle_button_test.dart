import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  testWidgets('narrow title', (tester) async {
    const leading = Key('leading');
    const title = Key('title');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 48, height: 48),
        title: SizedBox(key: title, width: 128, height: 24),
      ),
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));

    expect(buttonRect.width, greaterThan(48 + 128));
    expect(buttonRect.height, 48);

    expect(leadingRect.left, buttonRect.left);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.left, greaterThan(leadingRect.right));
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.right, buttonRect.right);
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);
  });

  testWidgets('tall title', (tester) async {
    const leading = Key('leading');
    const title = Key('title');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 24, height: 24),
        title: SizedBox(key: title, width: 128, height: 48),
      ),
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));

    expect(buttonRect.width, greaterThan(24 + 128));
    expect(buttonRect.height, 48);

    expect(leadingRect.left, buttonRect.left);
    expect(leadingRect.center.dy, titleRect.center.dy);
    expect(leadingRect.width, 24);
    expect(leadingRect.height, 24);

    expect(titleRect.left, greaterThan(leadingRect.right));
    expect(titleRect.top, buttonRect.top);
    expect(titleRect.right, buttonRect.right);
    expect(titleRect.width, 128);
    expect(titleRect.height, 48);
  });

  testWidgets('subtitle', (tester) async {
    const leading = Key('leading');
    const title = Key('title');
    const subtitle = Key('subtitle');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 48, height: 48),
        title: SizedBox(key: title, width: 128, height: 24),
        subtitle: SizedBox(key: subtitle, width: 192, height: 16),
      ),
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));
    final subtitleRect = tester.getRect(find.byKey(subtitle));

    expect(buttonRect.width, greaterThan(48 + 192));
    expect(buttonRect.height, greaterThan(48));

    expect(leadingRect.left, buttonRect.left);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.left, greaterThan(leadingRect.right));
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.right, lessThan(buttonRect.right));
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);

    expect(subtitleRect.left, titleRect.left);
    expect(subtitleRect.top, greaterThan(titleRect.bottom));
    expect(subtitleRect.right, greaterThan(titleRect.right));
    expect(subtitleRect.bottom, buttonRect.bottom);
    expect(subtitleRect.width, 192);
    expect(subtitleRect.height, 16);
  });

  testWidgets('narrow rtl title', (tester) async {
    const leading = Key('leading');
    const title = Key('title');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 48, height: 48),
        title: SizedBox(key: title, width: 128, height: 24),
      ),
      textDirection: TextDirection.rtl,
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));

    expect(buttonRect.width, greaterThan(48 + 128));
    expect(buttonRect.height, 48);

    expect(leadingRect.right, buttonRect.right);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.right, lessThan(leadingRect.left));
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.left, buttonRect.left);
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);
  });

  testWidgets('tall rtl title', (tester) async {
    const leading = Key('leading');
    const title = Key('title');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 24, height: 24),
        title: SizedBox(key: title, width: 128, height: 48),
      ),
      textDirection: TextDirection.rtl,
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));

    expect(buttonRect.width, greaterThan(24 + 128));
    expect(buttonRect.height, 48);

    expect(leadingRect.right, buttonRect.right);
    expect(leadingRect.center.dy, titleRect.center.dy);
    expect(leadingRect.width, 24);
    expect(leadingRect.height, 24);

    expect(titleRect.left, buttonRect.left);
    expect(titleRect.top, buttonRect.top);
    expect(titleRect.right, lessThan(leadingRect.left));
    expect(titleRect.width, 128);
    expect(titleRect.height, 48);
  });

  testWidgets('rtl subtitle', (tester) async {
    const leading = Key('leading');
    const title = Key('title');
    const subtitle = Key('subtitle');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 48, height: 48),
        title: SizedBox(key: title, width: 128, height: 24),
        subtitle: SizedBox(key: subtitle, width: 192, height: 16),
      ),
      textDirection: TextDirection.rtl,
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));
    final subtitleRect = tester.getRect(find.byKey(subtitle));

    expect(buttonRect.width, greaterThan(48 + 192));
    expect(buttonRect.height, greaterThan(48));

    expect(leadingRect.right, buttonRect.right);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.left, buttonRect.left);
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.right, lessThan(leadingRect.left));
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);

    expect(subtitleRect.left, titleRect.left);
    expect(subtitleRect.top, greaterThan(titleRect.bottom));
    expect(subtitleRect.right, greaterThan(titleRect.right));
    expect(subtitleRect.bottom, buttonRect.bottom);
    expect(subtitleRect.width, 192);
    expect(subtitleRect.height, 16);
  });

  testWidgets('theme spacing', (tester) async {
    const leading = Key('leading');
    const title = Key('title');
    const subtitle = Key('subtitle');

    await tester.pumpToggleButton(
      const YaruToggleButtonTheme(
        data: YaruToggleButtonThemeData(
          horizontalSpacing: 24,
          verticalSpacing: 12,
        ),
        child: YaruToggleButton(
          leading: SizedBox(key: leading, width: 48, height: 48),
          title: SizedBox(key: title, width: 128, height: 24),
          subtitle: SizedBox(key: subtitle, width: 192, height: 16),
        ),
      ),
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));
    final subtitleRect = tester.getRect(find.byKey(subtitle));

    expect(buttonRect.width, 48 + 24 + 192);
    expect(buttonRect.height, 24 + 12 + 12 + 16);

    expect(leadingRect.left, buttonRect.left);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.left, leadingRect.right + 24);
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.right, lessThan(subtitleRect.right));
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);

    expect(subtitleRect.left, titleRect.left);
    expect(subtitleRect.top, titleRect.bottom + 12);
    expect(subtitleRect.right, buttonRect.right);
    expect(subtitleRect.bottom, buttonRect.bottom);
    expect(subtitleRect.width, 192);
    expect(subtitleRect.height, 16);
  });

  testWidgets('rebuild', (tester) async {
    const leading = Key('leading');
    const title = Key('title');

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 24, height: 24),
        title: SizedBox(key: title, width: 96, height: 48),
      ),
    );

    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox(key: leading, width: 48, height: 48),
        title: SizedBox(key: title, width: 128, height: 24),
      ),
    );

    final buttonRect = tester.getRect(find.byType(YaruToggleButton));
    final leadingRect = tester.getRect(find.byKey(leading));
    final titleRect = tester.getRect(find.byKey(title));

    expect(buttonRect.width, greaterThan(48 + 128));
    expect(buttonRect.height, 48);

    expect(leadingRect.left, buttonRect.left);
    expect(leadingRect.top, buttonRect.top);
    expect(leadingRect.width, 48);
    expect(leadingRect.height, 48);

    expect(titleRect.left, greaterThan(leadingRect.right));
    expect(titleRect.center.dy, leadingRect.center.dy);
    expect(titleRect.right, buttonRect.right);
    expect(titleRect.width, 128);
    expect(titleRect.height, 24);
  });

  testWidgets('theme data', (tester) async {
    const data = YaruToggleButtonThemeData(
      horizontalSpacing: 1.2,
      verticalSpacing: 2.3,
    );
    expect(data, data.copyWith());
    expect(data, isNot(data.copyWith(horizontalSpacing: 3.4)));
    expect(
      data.copyWith(verticalSpacing: 3.4),
      data.copyWith(verticalSpacing: 3.4),
    );
  });

  testWidgets('ellipsize and wrap', (tester) async {
    await tester.pumpToggleButton(
      const YaruToggleButton(
        leading: SizedBox.shrink(),
        title: Text('title'),
        subtitle: Text('subtitle'),
      ),
    );

    final title = DefaultTextStyle.of(tester.element(find.text('title')));
    expect(title.softWrap, isFalse);
    expect(title.overflow, TextOverflow.ellipsis);

    final subtitle = DefaultTextStyle.of(tester.element(find.text('subtitle')));
    expect(subtitle.softWrap, isTrue);
    expect(subtitle.overflow, isNot(TextOverflow.ellipsis));
  });
}

extension YaruToggleButtonTester on WidgetTester {
  Future<void> pumpToggleButton(
    Widget widget, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final app = MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: Center(
            child: widget,
          ),
        ),
      ),
    );
    return pumpWidget(app);
  }
}
