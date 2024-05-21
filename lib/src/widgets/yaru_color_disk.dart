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
          statesController: WidgetStatesController({
            if (selected) WidgetState.selected,
          }),
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: ButtonStyleButton.allOrNull(EdgeInsets.zero),
            shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
              return CircleBorder(
                side: BorderSide(
                  color: color.withOpacity(
                    states.contains(WidgetState.selected) ||
                            states.contains(WidgetState.pressed)
                        ? 1.0
                        : states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.focused)
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
