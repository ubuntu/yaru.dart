import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_image_tile.dart';
import 'package:yaru_widgets/src/yaru_option_card.dart';

void main() {
  testWidgets('- YaruOptionCard Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        body: YaruOptionCard(
          selected: true,
          onSelected: (){},
          okIconData: Icons.analytics,
          bodyText: "Foo Body",
          titleText: "Foo Title",
        ),
      ),
    ));

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.text("Foo Body"), findsOneWidget);
    expect(find.text("Foo Title"), findsOneWidget);
  });
}

