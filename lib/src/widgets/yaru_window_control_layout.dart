import 'yaru_window_control.dart';

/// Defines the order and position in which [YaruWindowControl] items are presented.
///
/// YaruWindowControlType.maximize and YaruWindowControlType.restore are treated as the same button.
/// Only put one of these types in your YaruWindowControlLayout, otherwise the button will appear twice.

class YaruWindowControlLayout {
  const YaruWindowControlLayout(this.leftItems, this.rightItems);

  final List<YaruWindowControlType> leftItems;
  final List<YaruWindowControlType> rightItems;

  /// Parses the [gtk-decoration-layout](https://docs.gtk.org/gtk4/property.Settings.gtk-decoration-layout.html)
  /// string, as provided by GTK settings.
  ///
  /// It is up to the developer how to retrieve the string. For example, they can
  /// use the [gtk](https://pub.dev/packages/gtk) package.
  static YaruWindowControlLayout parseGTKSetting(
    String gtkDecorationLayoutString,
  ) {
    final splitSideStrings = gtkDecorationLayoutString.split(':');
    final leftItemStrings = splitSideStrings.first.split(',');
    final rightItemStrings = (splitSideStrings.length > 1)
        ? splitSideStrings.last.split(',')
        : <String>[];

    return YaruWindowControlLayout(
      _getControlTypesFromStrings(leftItemStrings),
      _getControlTypesFromStrings(rightItemStrings),
    );
  }

  static List<YaruWindowControlType> _getControlTypesFromStrings(
    List<String> gtkControls,
  ) {
    final decorations = List<YaruWindowControlType>.empty(growable: true);
    for (final gtkControl in gtkControls) {
      if (gtkControl.isNotEmpty) {
        switch (gtkControl) {
          case 'close':
            decorations.add(YaruWindowControlType.close);
            break;
          case 'minimize':
            decorations.add(YaruWindowControlType.minimize);
            break;
          case 'maximize':
            decorations.add(YaruWindowControlType.maximize);
            break;
          default: // anything else is not supported, including "icon" and "menu"
        }
      }
    }
    return decorations;
  }
}
