import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_extra_option_row.dart';
import 'package:yaru_widgets/src/yaru_option_button.dart';

void main() {
  testWidgets(
    'YaruExtraOptionRow widget build test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruExtraOptionRow(
              actionLabel: 'Repeat Keys',
              actionDescription: 'Key presses repeat when key is held down',
              value: true,
              onChanged: (_) {},
              onPressed: () {},
              iconData: const IconData(0),
            ),
          ),
        ),
      );

      expect(find.text('Repeat Keys'), findsOneWidget);
      expect(find.byType(YaruOptionButton), findsOneWidget);

      /// The [byWidgetPredicate] method of the [CommonFinders] class is to specify the
      /// type of any widget and so examine the state of that type.
      final finder = find.byWidgetPredicate(
        (widget) => widget is Switch && widget.value == true,
        description: 'Switch is enabled',
      );
      expect(finder, findsOneWidget);
    },
  );
}
