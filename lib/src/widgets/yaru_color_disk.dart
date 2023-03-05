import 'package:flutter/material.dart';

class YaruColorDisk extends StatelessWidget {
  const YaruColorDisk({
    super.key,
    required this.onPressed,
    required this.color,
    required this.selected,
  });

  final VoidCallback onPressed;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          statesController: MaterialStatesController({
            if (selected) MaterialState.selected,
          }),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: ButtonStyleButton.allOrNull(EdgeInsets.zero),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((states) {
              return CircleBorder(
                side: BorderSide(
                  color: color.withOpacity(
                    states.contains(MaterialState.selected) ||
                            states.contains(MaterialState.pressed)
                        ? 1.0
                        : states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused)
                            ? 0.5
                            : 0,
                  ),
                ),
              );
            }),
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
