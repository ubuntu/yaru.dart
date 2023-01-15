import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'yaru_back_button_theme.dart';
import 'yaru_icon_button.dart';

/// A Yaru style back button.
class YaruBackButton extends StatelessWidget {
  /// Creates a [YaruBackButton].
  const YaruBackButton({
    super.key,
    this.onPressed,
    this.style,
  });

  /// An optional callback that is called when the button is pressed.
  ///
  /// By default, [Navigator.maybePop] is called.
  final VoidCallback? onPressed;

  /// The style of the button. Overrides [YaruBackButtonThemeData.style] and
  /// defaults to [YaruBackButtonStyle.square].
  final YaruBackButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = YaruBackButtonTheme.of(context);
    final shape = (style ?? theme?.style) == YaruBackButtonStyle.rounded
        ? const CircleBorder()
        : const BeveledRectangleBorder();

    return YaruIconButton(
      icon: const Icon(YaruIcons.go_previous),
      style: ButtonStyle(
        shape: ButtonStyleButton.allOrNull(shape),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
