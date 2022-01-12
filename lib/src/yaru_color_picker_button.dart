import 'package:flutter/material.dart';

/// A squared [OutlinedButton] with a colorable disk inside and a [VoidCallback] forwarded to [onPressed]
class YaruColorPickerButton extends StatelessWidget {
  const YaruColorPickerButton({
    Key? key,
    required this.color,
    required this.onPressed,
  })  : size = 40.0,
        super(key: key);

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
        onPressed: onPressed,
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
