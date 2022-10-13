import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'yaru_icon_button.dart';

class YaruCloseButton extends StatelessWidget {
  const YaruCloseButton({
    Key? key,
    this.enabled = true,
    this.onPressed,
  }) : super(key: key);

  final bool enabled;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return YaruIconButton(
      style: IconButton.styleFrom(
        fixedSize: const Size.square(34),
      ),
      onPressed:
          isCloseable ? onPressed ?? () => Navigator.of(context).pop() : null,
      icon: const Icon(YaruIcons.window_close),
    );
  }
}
