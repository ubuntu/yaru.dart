import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_option_button.dart';

void main() {
  testWidgets('YaruOptionsButton Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: YaruOptionButton(
          onPressed: () {},
          iconData: const IconData(0),
        ),
      ),
    ));

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
