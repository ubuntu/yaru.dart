import 'package:flutter/material.dart';

const _kWindowControlSize = 24.0;
const _kWindowControlIconSize = 8.0;
const _kWindowControlIconStrokeWidth = 1.0;
const _kWindowControlIconStrokeAlign = _kWindowControlIconStrokeWidth / 2;
const _kWindowControlAnimationDuration = Duration(milliseconds: 500);
const _kWindowControlAnimationCurve = Curves.linear;

/// Defines the look of a [YaruWindowControl]
enum YaruWindowControlType {
  close,
  maximize,
  restore,
  minimize,
}

class YaruWindowControl extends StatefulWidget {
  const YaruWindowControl({super.key, required this.type});

  final YaruWindowControlType type;

  @override
  State<YaruWindowControl> createState() {
    return _YaruWindowControlState();
  }
}

class _YaruWindowControlState extends State<YaruWindowControl>
    with TickerProviderStateMixin {
  late YaruWindowControlType oldType;

  late CurvedAnimation _position;
  late AnimationController _positionController;

  @override
  void initState() {
    super.initState();

    oldType = widget.type;

    _positionController = AnimationController(
      duration: _kWindowControlAnimationDuration,
      value: widget.type == YaruWindowControlType.maximize ? 0.0 : 1.0,
      vsync: this,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: _kWindowControlAnimationCurve,
    );
  }

  @override
  void didUpdateWidget(covariant YaruWindowControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type) {
      oldType = widget.type;

      if (oldWidget.type == YaruWindowControlType.maximize &&
          widget.type == YaruWindowControlType.restore) {
        _positionController.forward();
      } else if (oldWidget.type == YaruWindowControlType.restore &&
          widget.type == YaruWindowControlType.maximize) {
        _positionController.reverse();
      } else if (widget.type == YaruWindowControlType.restore) {
        _positionController.value = 0.0;
      } else if (widget.type == YaruWindowControlType.maximize) {
        _positionController.value = 1.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _position,
      builder: (context, child) => RepaintBoundary(
        child: CustomPaint(
          size: const Size.square(_kWindowControlSize),
          painter: _YaruWindowControlPainter(
            type: widget.type,
            oldType: oldType,
            iconColor: Theme.of(context).colorScheme.onSurface,
            position: _position.value,
          ),
        ),
      ),
    );
  }
}

class _YaruWindowControlPainter extends CustomPainter {
  _YaruWindowControlPainter({
    required this.type,
    required this.oldType,
    required this.iconColor,
    required this.position,
  });

  final YaruWindowControlType type;
  final YaruWindowControlType oldType;

  final Color iconColor;

  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size);

    final rect = Rect.fromLTWH(
      (size.width - _kWindowControlIconSize) / 2 +
          _kWindowControlIconStrokeAlign,
      (size.height - _kWindowControlIconSize) / 2 +
          _kWindowControlIconStrokeAlign,
      _kWindowControlIconSize - _kWindowControlIconStrokeAlign * 2,
      _kWindowControlIconSize - _kWindowControlIconStrokeAlign * 2,
    );

    switch (type) {
      case YaruWindowControlType.close:
        _drawClose(canvas, size, rect);
        break;
      case YaruWindowControlType.minimize:
        _drawMinimize(canvas, size, rect);
        break;
      case YaruWindowControlType.restore:
      case YaruWindowControlType.maximize:
        _drawRestoreMaximize(canvas, size, rect);
        break;
    }
  }

  void _drawCircle(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.white12
        ..style = PaintingStyle.fill,
    );
  }

  void _drawClose(Canvas canvas, Size size, Rect rect) {
    canvas.drawLine(rect.topLeft, rect.bottomRight, _getIconPaint());
    canvas.drawLine(rect.topRight, rect.bottomLeft, _getIconPaint());
  }

  void _drawRestoreMaximize(Canvas canvas, Size size, Rect drawRect) {
    const gap = _kWindowControlIconStrokeWidth + 1;

    final rect = Rect.fromLTRB(
      drawRect.left,
      drawRect.top + gap * position,
      drawRect.right - gap * position,
      drawRect.bottom,
    );

    final path = Path()
      ..moveTo(
        drawRect.topLeft.dx + gap,
        drawRect.topLeft.dy,
      )
      ..lineTo(
        drawRect.topRight.dx,
        drawRect.topRight.dy,
      )
      ..lineTo(
        drawRect.bottomRight.dx,
        drawRect.bottomRight.dy - gap,
      );

    final color = _getIconPaint().color;

    canvas.drawRect(rect, _getIconPaint());
    canvas.drawPath(path, _getIconPaint()..color = color.withOpacity(position));
  }

  void _drawMinimize(Canvas canvas, Size size, Rect rect) {
    canvas.drawLine(
      Offset(rect.bottomLeft.dx, rect.bottomLeft.dy - 1.0),
      Offset(rect.bottomRight.dx, rect.bottomRight.dy - 1.0),
      _getIconPaint(),
    );
  }

  Paint _getIconPaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kWindowControlIconStrokeWidth
      ..color = iconColor
      ..strokeCap = StrokeCap.square;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
