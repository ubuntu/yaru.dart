import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yaru/widgets.dart';

abstract class VoidCallback {
  void call();
}

class VoidCallbackMock extends Mock implements VoidCallback {}

void main() {
  testWidgets('has no dropdown button', (tester) async {
    final onPressed = VoidCallbackMock();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruSplitButton(
                child: const Text('button'),
                onPressed: onPressed.call,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('button'), findsOne);
    final finder = find.byType(ElevatedButton);
    expect(finder, findsOne);

    await tester.tap(finder.first);
    verify(onPressed.call).called(1);
  });

  testWidgets('can be pressed', (tester) async {
    final onPressed = VoidCallbackMock();
    final onOptionsPressed = VoidCallbackMock();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruSplitButton(
                child: const Text('button'),
                onPressed: onPressed.call,
                onOptionsPressed: onOptionsPressed.call,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('button'), findsOne);
    final finder = find.byType(ElevatedButton);
    expect(finder, findsExactly(2));

    await tester.tap(finder.first);
    verify(onPressed.call).called(1);
    verifyNever(onOptionsPressed.call);

    await tester.tap(finder.at(1));
    verify(onOptionsPressed.call).called(1);
  });

  testWidgets('disabled can\'t be pressed', (tester) async {
    final onPressed = VoidCallbackMock();
    final onOptionsPressed = VoidCallbackMock();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruSplitButton(
                child: const Text('button'),
                onOptionsPressed: onOptionsPressed.call,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('button'), findsOne);
    final finder = find.byType(ElevatedButton);
    expect(finder, findsExactly(2));

    await tester.tap(finder.first);
    verifyNever(onPressed.call);
    verifyNever(onOptionsPressed.call);

    await tester.tap(finder.at(1));
    verifyNever(onPressed.call);
    verify(onOptionsPressed.call).called(1);
  });
}
