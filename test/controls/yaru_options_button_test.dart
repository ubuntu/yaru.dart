import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/controls/yaru_option_button.dart';

void main() {
  testWidgets('YaruOptionsButton Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruOptionButton(
            onPressed: () {},
            child: const Icon(Icons.flutter_dash),
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
