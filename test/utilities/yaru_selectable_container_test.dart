import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/utilities/yaru_selectable_container.dart';

void main() {
  testWidgets('- YaruImageTile Test', (tester) async {
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
          body: YaruSelectableContainer(
            selected: true,
            child: kIsWeb
                ? Image.network(
                    'assets/ubuntuhero.jpg',
                    filterQuality: FilterQuality.low,
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File('assets/ubuntuhero.jpg'),
                    filterQuality: FilterQuality.low,
                    fit: BoxFit.fill,
                  ),
            onTap: () => selected = !selected,
          ),
        ),
      ),
    );

    expect(find.byType(YaruSelectableContainer), findsOneWidget);
  });
}
