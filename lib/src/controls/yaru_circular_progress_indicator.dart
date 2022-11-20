import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'yaru_progress_indicator.dart';

const double _kMinCircularProgressIndicatorSize = 36.0;
const double _kDefaultCircularProgressStrokeWidth = 6;

class YaruCircularProgressIndicator extends YaruProgressIndicator {
  /// Creates a Yaru circular progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruCircularProgressIndicator({
    super.key,
    super.value,
    this.strokeWidth = _kDefaultCircularProgressStrokeWidth,
    super.color,
    super.valueColor,
    super.semanticsLabel,
    super.semanticsValue,
  });

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  @override
  _YaruCircularProgressIndicatorState createState() =>
      _YaruCircularProgressIndicatorState();
}

class _YaruCircularProgressIndicatorState
    extends State<YaruCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _rotationTween =
      Tween(begin: 0.0, end: math.pi * 12)
          .chain(CurveTween(curve: kIndeterminateAnimationCurve));
  static final Animatable<double> _speedTween = Tween(begin: -1.0, end: 1.0)
      .chain(CurveTween(curve: kIndeterminateAnimationCurve));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: kIndeterminateAnimationDuration),
      vsync: this,
    );

    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(YaruCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      return _buildContainer(
        context,
        CustomPaint(
          painter: _DeterminateYaruCircularProgressIndicatorPainter(
            widget.value!,
            widget.getValueColor(context),
            widget.strokeWidth,
            Directionality.of(context),
          ),
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildContainer(
          context,
          CustomPaint(
            painter: _IndeterminateYaruCircularProgressIndicatorPainter(
              widget.getValueColor(context),
              widget.strokeWidth,
              _rotationTween.evaluate(_controller),
              _speedTween.evaluate(_controller).abs(),
              Directionality.of(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    return widget.buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinCircularProgressIndicatorSize,
          minHeight: _kMinCircularProgressIndicatorSize,
        ),
        child: child,
      ),
    );
  }
}

class _IndeterminateYaruCircularProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruCircularProgressIndicatorPainter(
    this.color,
    this.strokeWidth,
    this.rotationAngle,
    this.speed,
    this.textDirection,
  ) : super();

  final Color color;
  final double strokeWidth;
  final double rotationAngle;
  final double speed;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    const circleThird = math.pi * 2 / 3;

    final gradient = SweepGradient(
      startAngle: 0.0 + rotationAngle,
      endAngle: circleThird + rotationAngle,
      tileMode: TileMode.repeated,
      colors: [
        color.withAlpha(0),
        color.withAlpha(20 + (230 * speed).toInt()),
        color.withAlpha(250)
      ],
      stops: const [0.15, 0.75, 1],
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);
    const sweepAngle = circleThird;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    for (var i = 0; i < 3; i++) {
      final startAngle = rotationAngle + circleThird * i;
      canvas.drawArc(rect, startAngle, sweepAngle, false, gradientPaint);
    }

    // Draw circles after arcs, so they look on top
    for (var i = 0; i < 3; i++) {
      final startAngle = rotationAngle + circleThird * i;
      canvas.drawCircle(
        Offset(
          math.cos(startAngle) * radius + center.dx,
          math.sin(startAngle) * radius + center.dy,
        ),
        strokeWidth / 2,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    _IndeterminateYaruCircularProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.speed != speed ||
        oldDelegate.textDirection != textDirection;
  }
}

class _DeterminateYaruCircularProgressIndicatorPainter extends CustomPainter {
  const _DeterminateYaruCircularProgressIndicatorPainter(
    this.value,
    this.color,
    this.width,
    this.textDirection,
  ) : super();

  final double value;
  final Color color;
  final double width;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final revisedValue = value >= 0 && value <= 1
        ? value
        : value < 0
            ? 0
            : 1;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    const startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * revisedValue;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    final backgroundPaint = Paint()
      ..color = color.withOpacity(.25)
      ..strokeWidth = width > 2 ? width - 2 : width
      ..style = PaintingStyle.stroke;
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, strokePaint);
  }

  @override
  bool shouldRepaint(
    _DeterminateYaruCircularProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.width != width ||
        oldDelegate.textDirection != textDirection;
  }
}
