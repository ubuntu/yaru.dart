import 'package:flutter/material.dart';

/// A squared [OutlinedButton] with a colorable disk inside and a [VoidCallback] forwarded to [onPressed]
class YaruColorPickerButton extends StatelessWidget {
  const YaruColorPickerButton({
    Key? key,
    this.enabled = true,
    required this.color,
    required this.onPressed,
    this.size = 40.0,
  }) : super(key: key);

  /// Whether or not we can interact with the button
  final bool enabled;

  /// Is executed when pressing the button.
  final VoidCallback onPressed;

  /// Colors the colored disk.
  final Color color;

  /// Can be changed but defaults to 40.0
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: enabled ? onPressed : null,
        child: SizedBox(
          width: size / 2,
          height: size / 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: color),
          ),
        ),
      ),
    );
  }
}
