import 'package:flutter/material.dart';
import 'package:yaru/icons.dart';

import 'yaru_back_button_theme.dart';
import 'yaru_icon_button.dart';

/// A Yaru style back button.
class YaruBackButton extends StatelessWidget {
  /// Creates a [YaruBackButton].
  const YaruBackButton({
    super.key,
    this.onPressed,
    this.style,
    this.icon,
  });

  /// An optional callback that is called when the button is pressed.
  ///
  /// By default, [Navigator.maybePop] is called.
  final VoidCallback? onPressed;

  /// The style of the button. Overrides [YaruBackButtonThemeData.style] and
  /// defaults to [YaruBackButtonStyle.square].
  final YaruBackButtonStyle? style;

  /// Optional icon used inside the [YaruIconButton]
  /// Defaults to `const Icon(YaruIcons.go_previous)`
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = YaruBackButtonTheme.of(context);
    final round = (style ?? theme?.style) == YaruBackButtonStyle.rounded;
    final shape = round ? const CircleBorder() : const BeveledRectangleBorder();
    final button = YaruIconButton(
      icon: icon ?? const Icon(YaruIcons.go_previous),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
    return round ? Center(child: button) : button;
  }
}
