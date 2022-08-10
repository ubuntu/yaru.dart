import 'package:flutter/widgets.dart';

/// This is an optional widget, which avoid line wrap in sidebar
/// It alters the children text style with: maxLines=1 and overflow=TextOverflow.ellipsis
/// This allow to have the same look as the nautilus sidebar when horizontal space becomes too small
class YaruPageItemTitle extends StatelessWidget {
  const YaruPageItemTitle(this.child, {Key? key}) : super(key: key);

  /// Shortcut to directly wrap a string into a [Text] widget
  YaruPageItemTitle.text(String text, {Key? key})
      : child = Text(text),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
