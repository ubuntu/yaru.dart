import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yaru/src/widgets/yaru_edge_focus_interceptor.dart';

abstract class VoidCallback {
  void call();
}

class VoidCallbackMock extends Mock implements VoidCallback {}

void main() {
  final previousFocusNode = FocusNode();
  final nextFocusNode = FocusNode();
  final previousCallback = VoidCallbackMock();
  final nextCallback = VoidCallbackMock();

  Widget builder() {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Focus(
              focusNode: previousFocusNode,
              child: const SizedBox.shrink(),
            ),
            YaruEdgeFocusInterceptor(
              onFocusFromPreviousNode: previousCallback.call,
              onFocusFromNextNode: nextCallback.call,
              child: const Focus(
                child: SizedBox.shrink(),
              ),
            ),
            Focus(
              focusNode: nextFocusNode,
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('the widget react to previous focus', (tester) async {
    await tester.pumpWidget(builder());
    previousFocusNode.requestFocus();
    previousFocusNode.nextFocus();
    await tester.pump();

    verify(previousCallback.call).called(1);
    verifyNever(nextCallback.call);
  });

  testWidgets('the widget react to next focus', (tester) async {
    await tester.pumpWidget(builder());
    nextFocusNode.requestFocus();
    nextFocusNode.previousFocus();
    await tester.pump();

    verify(nextCallback.call).called(1);
    verifyNever(previousCallback.call);
  });
}
