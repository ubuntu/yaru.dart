import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/widgets/yaru_circular_progress_indicator_theme.dart';

import 'yaru_progress_indicator.dart';

const double _kMinCircularProgressIndicatorSize = 36.0;

class YaruCircularProgressIndicator extends YaruProgressIndicator {
  /// Creates a Yaru circular progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruCircularProgressIndicator({
    super.key,
    super.value,
    super.strokeWidth,
    super.trackStrokeWidth,
    super.color,
    super.valueColor,
    super.trackColor,
    super.trackValueColor,
    super.semanticsLabel,
    super.semanticsValue,
  });

  @override
  State<YaruCircularProgressIndicator> createState() =>
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
    final theme = Theme.of(context);
    final progressTheme = YaruCircularProgressIndicatorTheme.of(context);

    final color = widget.valueColor?.value ??
        widget.color ??
        progressTheme?.color ??
        theme.colorScheme.primary;
    final defaultTrackColor =
        widget.value != null ? color.withOpacity(.25) : color.withOpacity(.1);
    final trackColor = widget.trackValueColor?.value ??
        widget.trackColor ??
        progressTheme?.trackColor ??
        defaultTrackColor;
    final strokeWidth =
        widget.strokeWidth ?? progressTheme?.strokeWidth ?? kDefaultStrokeWidth;
    final trackStrokeWidth = widget.trackStrokeWidth ??
        progressTheme?.trackStrokeWidth ??
        widget.computeDefaultTrackSize(strokeWidth);

    Widget buildContainer(BuildContext context, Widget child) {
      return widget.buildSemanticsWrapper(
        context: context,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: _kMinCircularProgressIndicatorSize,
            minHeight: _kMinCircularProgressIndicatorSize,
          ),
          child: RepaintBoundary(
            child: child,
          ),
        ),
      );
    }

    if (widget.value != null) {
      return buildContainer(
        context,
        CustomPaint(
          painter: _DeterminateYaruCircularProgressIndicatorPainter(
            widget.value!,
            color,
            trackColor,
            strokeWidth,
            trackStrokeWidth,
            Directionality.of(context),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return buildContainer(
          context,
          CustomPaint(
            painter: _IndeterminateYaruCircularProgressIndicatorPainter(
              color,
              trackColor,
              strokeWidth,
              trackStrokeWidth,
              _rotationTween.evaluate(_controller),
              _speedTween.evaluate(_controller).abs(),
              Directionality.of(context),
            ),
          ),
        );
      },
    );
  }
}

class _IndeterminateYaruCircularProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruCircularProgressIndicatorPainter(
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.trackStrokeWidth,
    this.rotationAngle,
    this.speed,
    this.textDirection,
  ) : super();

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
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
        color.withAlpha(250),
      ],
      stops: const [0.15, 0.75, 1],
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);
    const sweepAngle = circleThird;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gradientStrokePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final trackStrokePaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth / 2
      ..style = PaintingStyle.stroke;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    canvas.drawArc(rect, 0, math.pi * 2, false, trackStrokePaint);

    for (var i = 0; i < 3; i++) {
      final startAngle = rotationAngle + circleThird * i;
      canvas.drawArc(rect, startAngle, sweepAngle, false, gradientStrokePaint);
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
    this.trackColor,
    this.strokeWidth,
    this.trackStrokeWidth,
    this.textDirection,
  ) : super();

  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final revisedValue = value >= 0 && value <= 1
        ? value
        : value < 0
            ? 0
            : 1;
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);
    const startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * revisedValue;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final candidateTrackHeight = (strokeWidth / 3 * 2).truncate();
    final trackHeight =
        (candidateTrackHeight + (candidateTrackHeight.isEven ? 0 : 1))
            .toDouble();

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final trackStrokePaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackHeight
      ..style = PaintingStyle.stroke;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    canvas.drawArc(rect, 0, math.pi * 2, false, trackStrokePaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, strokePaint);
  }

  @override
  bool shouldRepaint(
    _DeterminateYaruCircularProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.textDirection != textDirection;
  }
}
