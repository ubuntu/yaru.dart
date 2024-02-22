import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/gtk.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yaru/src/settings.dart';

import 'settings_test.mocks.dart';

@GenerateMocks([GtkSettings])
void main() {
  test('getThemeName', () async {
    final gtk = MockGtkSettings();
    when(gtk.getProperty(kGtkThemeName)).thenReturn('foo');

    final settings = YaruGtkSettings(gtk);
    expect(settings.getThemeName(), 'foo');
  });

  test('themeNameChanged', () async {
    final themeChanged = StreamController<String?>(sync: true);

    final gtk = MockGtkSettings();
    when(gtk.notifyProperty(kGtkThemeName))
        .thenAnswer((_) => themeChanged.stream);

    final settings = YaruGtkSettings(gtk);
    settings.themeNameChanged.listen(expectAsync1((ev) => expect(ev, 'bar')));

    themeChanged.add('bar');
  });
}
