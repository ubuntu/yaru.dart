import 'package:flutter/material.dart';

class YaruOptionButton extends StatelessWidget {
  /// Creates an [OutlinedButton] with Yaru theme.
  /// The button have `height` and `width` of 40.
  ///
  /// for example:
  /// ```dart
  ///  YaruOptionButton(
  ///           iconData: YaruIcons.search,
  ///           onPressed: () {},
  ///         ),
  /// ```
  const YaruOptionButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  /// Callback that gets invoked when the button is clicked.
  final VoidCallback? onPressed;

  /// The [IconData] is place as a child of [OutlinedButton].
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: onPressed,
        child: Icon(iconData),
      ),
    );
  }
}
