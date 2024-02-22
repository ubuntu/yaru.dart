import 'package:flutter/material.dart';

class YaruPlaceholderIcon extends StatelessWidget {
  const YaruPlaceholderIcon({
    super.key,
    required this.size,
    this.borderRadius,
  });

  /// Determines the icon canvas size.
  final Size size;

  /// Border radius used to build the clip widget.
  /// If null, it defaults to an oval clip.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // https://github.com/ubuntu-flutter-community/software/issues/798#issuecomment-1398266697
    final backgroundColor = brightness == Brightness.light
        ? const Color(0xFFC8C7C7)
        : const Color(0xFF5c5c5c);
    final detail1Color = brightness == Brightness.light
        ? const Color(0xFFEEEDED)
        : const Color(0xFF737373);
    final detail2Color = brightness == Brightness.light
        ? const Color(0xFFD9D9D9)
        : const Color(0xFF616161);

    return RepaintBoundary(
      child: _buildClip(
        CustomPaint(
          size: size,
          painter: _YaruPlaceholderIconPainter(
            size: size,
            backgroundColor: backgroundColor,
            detail1Color: detail1Color,
            detail2Color: detail2Color,
          ),
        ),
      ),
    );
  }

  Widget _buildClip(Widget child) {
    if (borderRadius == null) {
      return ClipOval(child: child);
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: child,
    );
  }
}

class _YaruPlaceholderIconPainter extends CustomPainter {
  _YaruPlaceholderIconPainter({
    required this.size,
    required this.backgroundColor,
    required this.detail1Color,
    required this.detail2Color,
  });

  final Size size;
  final Color backgroundColor;
  final Color detail1Color;
  final Color detail2Color;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    _drawBackground(canvas, size);
    _drawObject1(canvas, size);
    _drawObject2(canvas, size);
    _drawObject3(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );
  }

  void _drawObject1(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(_computeX(131), _computeY(0))
      ..lineTo(_computeX(11), _computeY(31.596))
      ..lineTo(_computeX(40.583), _computeY(0))
      ..close();

    canvas.drawPath(path, Paint()..color = detail1Color);
  }

  void _drawObject2(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(_computeX(40.583), _computeY(0))
      ..lineTo(_computeX(11), _computeY(31.596))
      ..lineTo(_computeX(23.834), _computeY(0))
      ..close();

    canvas.drawPath(path, Paint()..color = detail2Color);
  }

  void _drawObject3(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(_computeX(23.834), _computeY(0))
      ..lineTo(_computeX(11), _computeY(31.596))
      ..lineTo(_computeX(0), _computeY(51.496))
      ..lineTo(_computeX(0), _computeY(0))
      ..close();

    canvas.drawPath(path, Paint()..color = detail1Color);
  }

  // The svg reference was 131 x 51.496
  // We want the icon to be scalled depending on the widget height only
  double _computeX(double x) => size.width - (x / 51.496 * size.height);
  double _computeY(double y) => size.height - (y / 51.496 * size.height);

  @override
  bool shouldRepaint(_YaruPlaceholderIconPainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.detail1Color != detail1Color ||
        oldDelegate.detail2Color != detail2Color;
  }
}
