import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DraggablePage extends StatelessWidget {
  const DraggablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        Container(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
          child: SizedBox(
            width: 500,
            height: 250,
            child: Stack(
              children: [
                YaruDraggable(
                  initialPosition: Offset(0, 0),
                  onDragUpdate: (currentPosition, nextPosition) {
                    double dx = nextPosition.dx;
                    double dy = nextPosition.dy;

                    if (dx < 0) dx = 0;
                    if (dy < 0) dy = 0;
                    if (dx > 500 - 192) dx = 500 - 192;
                    if (dy > 250 - 108) dy = 250 - 108;

                    return Offset(dx, dy);
                  },
                  childBuilder: (context, position, isDragging, isHovering) =>
                      SizedBox(
                    width: 192,
                    height: 108,
                    child: AnimatedOpacity(
                      opacity: isDragging ? 1 : .85,
                      duration: Duration(milliseconds: 100),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(width: 10)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            position.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  cursor: SystemMouseCursors.grab,
                  dragCursor: SystemMouseCursors.grabbing,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
