import 'package:flutter/material.dart';

/// The size of [YaruWindowControl].
const kYaruWindowControlSize = 24.0;

const _kWindowControlIconSize = 8.0;
const _kWindowControlIconStrokeWidth = 1.0;
const _kWindowControlIconStrokeAlign = _kWindowControlIconStrokeWidth / 2;
const _kWindowControlIconAnimationDuration = Duration(milliseconds: 500);
const _kWindowControlAnimationCurve = Curves.linear;
const _kWindowControlBackgroundAnimationDuration = Duration(milliseconds: 200);
const _kWindowControlBackgroundOpacity = 0.1;
const _kWindowControlBackgroundOpacityHover = 0.15;
const _kWindowControlBackgroundOpacityActive = 0.2;
const _kWindowControlBackgroundOpacityDisabled = 0.05;

/// Defines the look of a [YaruWindowControl]
enum YaruWindowControlType {
  close,
  maximize,
  restore,
  minimize,
}

class YaruWindowControl extends StatefulWidget {
  const YaruWindowControl({
    super.key,
    required this.type,
    required this.onTap,
  });

  final YaruWindowControlType type;

  final GestureTapCallback? onTap;

  @override
  State<YaruWindowControl> createState() {
    return _YaruWindowControlState();
  }
}

class _YaruWindowControlState extends State<YaruWindowControl>
    with TickerProviderStateMixin {
  bool _hover = false;
  bool _active = false;

  bool get interactive => widget.onTap != null;

  late YaruWindowControlType oldType;

  late CurvedAnimation _position;
  late AnimationController _positionController;

  @override
  void initState() {
    super.initState();

    oldType = widget.type;

    _positionController = AnimationController(
      duration: _kWindowControlIconAnimationDuration,
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
  void dispose() {
    _positionController.dispose();

    super.dispose();
  }

  void _handleHover(bool hover) {
    setState(() {
      _hover = hover;

      if (!hover) {
        _active = false;
      }
    });
  }

  void _handleActive(bool active) {
    setState(() {
      _active = active;
    });
  }

  Color _getColor(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    if (!interactive) {
      return onSurface.withOpacity(_kWindowControlBackgroundOpacityDisabled);
    }

    return _active
        ? onSurface.withOpacity(_kWindowControlBackgroundOpacityActive)
        : _hover
            ? onSurface.withOpacity(_kWindowControlBackgroundOpacityHover)
            : onSurface.withOpacity(_kWindowControlBackgroundOpacity);
  }

  Widget _buildEventDetectors(Widget child) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _handleActive(true),
        onTapUp: (_) => _handleActive(false),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildEventDetectors(
      RepaintBoundary(
        child: AnimatedContainer(
          duration: _kWindowControlBackgroundAnimationDuration,
          decoration: BoxDecoration(
            color: _getColor(context),
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: kYaruWindowControlSize,
            child: Center(
              child: AnimatedBuilder(
                animation: _position,
                builder: (context, child) => CustomPaint(
                  size: const Size.square(_kWindowControlIconSize),
                  painter: _YaruWindowControlPainter(
                    type: widget.type,
                    oldType: oldType,
                    iconColor: Theme.of(context).colorScheme.onSurface,
                    position: _position.value,
                    interactive: interactive,
                  ),
                ),
              ),
            ),
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
    required this.interactive,
  });

  final YaruWindowControlType type;
  final YaruWindowControlType oldType;
  final Color iconColor;
  final double position;
  final bool interactive;

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTWH(
      _kWindowControlIconStrokeAlign,
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
        drawRect.topLeft.dx + (1 + _kWindowControlIconStrokeAlign),
        drawRect.topLeft.dy,
      )
      ..lineTo(
        drawRect.topRight.dx,
        drawRect.topRight.dy,
      )
      ..lineTo(
        drawRect.bottomRight.dx,
        drawRect.bottomRight.dy - (1 + _kWindowControlIconStrokeAlign),
      );

    canvas.drawRect(rect, _getIconPaint());
    canvas.drawPath(
      path,
      _getIconPaint()..color = iconColor.withOpacity(.5 * position),
    );
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
      ..color = iconColor.withOpacity(interactive ? 1.0 : 0.5)
      ..strokeCap = StrokeCap.square;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
