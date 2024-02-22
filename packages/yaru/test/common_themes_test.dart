import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:yaru/src/themes/yaru.dart';

void main() {
  testWidgets('consistent page transitions', (_) async {
    const platforms = [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ];
    final builders = yaruLight.pageTransitionsTheme.builders;
    final first = builders.entries.first.value;
    var allEqual = false;

    for (var entry in builders.entries) {
      if (platforms.contains(entry.key)) {
        allEqual = entry.value == first;
      }
    }
    expect(allEqual, isTrue);
  });
}
