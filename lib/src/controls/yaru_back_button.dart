import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'yaru_icon_button.dart';

/// A Yaru style back button.
class YaruBackButton extends StatelessWidget {
  /// Creates a [YaruBackButton].
  const YaruBackButton({super.key, this.onPressed});

  /// An optional callback that is called when the button is pressed.
  ///
  /// By default, [Navigator.maybePop] is called.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return YaruIconButton(
      icon: const Icon(YaruIcons.go_previous),
      style: ButtonStyle(
        shape: ButtonStyleButton.allOrNull(const BeveledRectangleBorder()),
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
