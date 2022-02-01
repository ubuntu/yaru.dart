import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_image_tile.dart';

void main() {
  testWidgets('- YaruImageTile Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        body: YaruImageTile(
          currentlySelected: true,
          path: "images/filename",
          onTap: () {},
        ),
      ),
    ));

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
