import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

void main() {
  test('navigation notifies only when a previous or next segment exists', () {
    final controller = YaruSegmentedEntryController(length: 3);
    addTearDown(controller.dispose);
    final indices = <int>[];
    controller.addListener(() => indices.add(controller.index));

    expect(controller.maybeSelectPreviousSegment(), isFalse);
    expect(indices, isEmpty);
    expect(controller.maybeSelectNextSegment(), isTrue);
    expect(controller.maybeSelectNextSegment(), isTrue);
    expect(controller.maybeSelectNextSegment(), isFalse);
    expect(indices, [1, 2]);
    expect(controller.maybeSelectPreviousSegment(), isTrue);
    expect(controller.maybeSelectPreviousSegment(), isTrue);
    expect(controller.maybeSelectPreviousSegment(), isFalse);
    expect(indices, [1, 2, 1, 0]);
  });

  test('selecting an edge notifies even when it is already selected', () {
    final controller = YaruSegmentedEntryController(length: 3);
    addTearDown(controller.dispose);
    final indices = <int>[];
    controller.addListener(() => indices.add(controller.index));

    controller.selectFirstSegment();
    controller.selectLastSegment();
    controller.selectLastSegment();
    controller.selectFirstSegment();
    expect(indices, [0, 2, 2, 0]);
  });

  test('assigning the same index does not notify', () {
    final controller = YaruSegmentedEntryController(length: 3, initialIndex: 1);
    addTearDown(controller.dispose);
    final indices = <int>[];
    controller.addListener(() => indices.add(controller.index));

    controller.index = 1;
    expect(indices, isEmpty);
    controller.index = 2;
    controller.index = 2;
    expect(indices, [2]);
  });
}
