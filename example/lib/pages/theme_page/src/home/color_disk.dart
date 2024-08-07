import 'package:flutter/material.dart';

class ColorDisk extends StatelessWidget {
  const ColorDisk({
    super.key,
    this.onPressed,
    required this.color,
    required this.selected,
  });

  final VoidCallback? onPressed;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: CircleBorder(
              side: BorderSide(
                color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
            ),
          ),
          onPressed: onPressed,
          child: SizedBox(
            height: 20,
            width: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
