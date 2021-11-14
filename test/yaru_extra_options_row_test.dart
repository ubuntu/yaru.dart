import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/yaru_extra_option_row.dart';

void main() {
  testWidgets(
    'ExtraOptionsGsettings widget build test',
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
      expect(find.byType(OutlinedButton), findsOneWidget);

      /// The [byWidgetPredicate] method of the [CommonFinders] class is to specify the
      /// type of any widget and so examine the state of that type.
      final finder = find.byWidgetPredicate(
        (widget) => widget is Switch && widget.value == true,
        description: 'Switch is enabled',
      );
      expect(finder, findsOneWidget);
    },
  );

  testWidgets(
    'when value=null returns SizedBox',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruExtraOptionRow(
              actionLabel: 'Repeat Keys',
              actionDescription: 'Key presses repeat when key is held down',
              value: null,
              onChanged: (_) {},
              onPressed: () {},
              iconData: const IconData(0),
            ),
          ),
        ),
      );

      expect(find.text('Repeat Keys'), findsNothing);
      expect(find.byType(Switch), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);

      /// returns [SizedBox] when value=null
      expect(find.byType(SizedBox), findsOneWidget);
    },
  );
}
