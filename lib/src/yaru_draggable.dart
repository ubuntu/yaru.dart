import 'package:flutter/material.dart';

/// A draggable positioned widget - have to be child of a [Stack]
class YaruDraggable extends StatefulWidget {
  const YaruDraggable({
    super.key,
    required this.childBuilder,
    required this.initialPosition,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.cursor,
    this.dragCursor,
  });

  /// Initial position of this element
  final Offset initialPosition;

  /// Builder callback of the child widget
  final Widget Function(
    BuildContext context,
    Offset position,
    bool isDragging,
    bool _isHovering,
  ) childBuilder;

  /// Callback called when this element starts to be dragged
  final void Function()? onDragStart;

  /// Callback called on each position update - usefull for collision checks
  ///
  /// It takes the current position and the candidate new one and should return the real next position.
  /// If null, the candidate next position is simply used.
  final Offset Function(
    Offset currentPosition,
    Offset nextPosition,
  )? onDragUpdate;

  /// Callback called when this element finished to be dragged
  final void Function()? onDragEnd;

  /// Cursor used when hovering this element, also used when dragging if [dragCursor] is null
  final MouseCursor? cursor;

  /// Cursor used when dragging this element
  final MouseCursor? dragCursor;

  @override
  _YaruDraggableState createState() => _YaruDraggableState();
}

class _YaruDraggableState extends State<YaruDraggable> {
  late Offset _position = widget.initialPosition;
  Offset _initialPosition = const Offset(0, 0);
  Offset _moveOffset = const Offset(0, 0);

  bool _isDragging = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: MouseRegion(
        cursor: _getCursor(),
        onEnter: (event) => setState(() {
          _isHovering = true;
        }),
        onExit: (event) => setState(() {
          _isHovering = false;
        }),
        child: GestureDetector(
          onPanStart: (details) => setState(() {
            _isDragging = true;
            _initialPosition = _position;
            if (widget.onDragStart != null) widget.onDragStart!();
          }),
          onPanUpdate: (details) => setState(() {
            _moveOffset += details.delta;

            final double dx = _initialPosition.dx + _moveOffset.dx;
            final double dy = _initialPosition.dy + _moveOffset.dy;

            _position = widget.onDragUpdate != null
                ? widget.onDragUpdate!(_position, Offset(dx, dy))
                : Offset(dx, dy);
          }),
          onPanEnd: (details) => setState(() {
            _isDragging = false;
            _moveOffset = const Offset(0, 0);
            if (widget.onDragEnd != null) widget.onDragEnd!();
          }),
          child: Builder(
            builder: (context) {
              return widget.childBuilder(
                context,
                _position,
                _isDragging,
                _isHovering,
              );
            },
          ),
        ),
      ),
    );
  }

  MouseCursor _getCursor() {
    if (widget.cursor == null) {
      return MouseCursor.defer;
    }

    if (widget.dragCursor != null && _isDragging) {
      return widget.dragCursor!;
    }

    return widget.cursor!;
  }
}
