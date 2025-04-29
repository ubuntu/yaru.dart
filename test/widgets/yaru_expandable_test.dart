import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/src/widgets/yaru_expandable.dart';
import 'package:yaru/src/widgets/yaru_icon_button.dart';

const kHeaderText = 'Lorem ipsum dolor sit amet';
const kContentText =
    'Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

void main() {
  testWidgets('icon is tappable', (tester) async {
    var isExpanded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruExpandable(
            isExpanded: isExpanded,
            onChange: (value) => isExpanded = value,
            header: const Text(kHeaderText),
            child: const Text(kContentText),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(YaruExpandable), findsOneWidget);
    expect(find.byType(YaruIconButton), findsOneWidget);
    expect(find.text(kHeaderText), findsOneWidget);
    expect(isExpanded, isFalse);

    await tester.tap(find.byType(YaruIconButton));
    await tester.pumpAndSettle();
    expect(isExpanded, isTrue);

    await tester.tap(find.byType(YaruIconButton));
    await tester.pumpAndSettle();
    expect(isExpanded, isFalse);
  });

  testWidgets('header text is tappable', (tester) async {
    var isExpanded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruExpandable(
            isExpanded: isExpanded,
            onChange: (value) => isExpanded = value,
            header: const Text(kHeaderText),
            child: const Text(kContentText),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(YaruExpandable), findsOneWidget);
    expect(find.byType(YaruIconButton), findsOneWidget);
    expect(find.text(kHeaderText), findsOneWidget);
    expect(isExpanded, isFalse);

    await tester.tap(find.text(kHeaderText));
    await tester.pumpAndSettle();
    expect(isExpanded, isTrue);

    await tester.tap(find.text(kHeaderText));
    await tester.pumpAndSettle();
    expect(isExpanded, isFalse);
  });

  testWidgets('header background is tappable', (tester) async {
    var isExpanded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruExpandable(
            isExpanded: isExpanded,
            onChange: (value) => isExpanded = value,
            header: const Text(kHeaderText),
            child: const Text(kContentText),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(YaruExpandable), findsOneWidget);
    expect(find.byType(YaruIconButton), findsOneWidget);
    expect(find.text(kHeaderText), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text(kHeaderText),
        matching: find.byType(GestureDetector),
      ),
      findsOneWidget,
    );
    expect(isExpanded, isFalse);

    await tester.tap(
      find.ancestor(
        of: find.text(kHeaderText),
        matching: find.byType(GestureDetector),
      ),
    );
    await tester.pumpAndSettle();
    expect(isExpanded, isTrue);

    await tester.tap(
      find.ancestor(
        of: find.text(kHeaderText),
        matching: find.byType(GestureDetector),
      ),
    );
    await tester.pumpAndSettle();
    expect(isExpanded, isFalse);
  });
}
