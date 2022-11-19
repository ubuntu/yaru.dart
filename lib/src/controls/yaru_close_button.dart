import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'yaru_icon_button.dart';

const _kCloseButtonSize = 32.0;

class YaruCloseButton extends StatelessWidget {
  const YaruCloseButton({
    super.key,
    this.enabled = true,
    this.onPressed,
    this.alignement = Alignment.center,
  });

  final bool enabled;
  final Function()? onPressed;
  final AlignmentGeometry alignement;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignement,
      child: YaruIconButton(
        padding: EdgeInsets.zero,
        onPressed: enabled ? onPressed ?? Navigator.of(context).maybePop : null,
        icon: const Icon(YaruIcons.window_close),
        iconSize: _kCloseButtonSize,
      ),
    );
  }
}
