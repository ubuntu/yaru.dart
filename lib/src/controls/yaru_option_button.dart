import 'package:flutter/material.dart';

class YaruOptionButton extends StatelessWidget {
  /// Creates an [OutlinedButton] with Yaru theme.
  /// The button have `height` and `width` of 40.
  ///
  /// for example:
  /// ```dart
  /// YaruOptionButton(
  ///   onPressed: () {},
  ///   icon: Icon(YaruIcons.search),
  /// ),
  /// ```
  const YaruOptionButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  /// Callback that gets invoked when the button is clicked.
  final VoidCallback? onPressed;

  /// The [Widget] is placed as a child of [OutlinedButton].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: IconTheme.merge(
        data: const IconThemeData(
          size: 24,
        ),
        child: child,
      ),
    );
  }
}
