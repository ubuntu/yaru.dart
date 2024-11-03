import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yaru/src/foundation/yaru_tween.dart';
import 'package:yaru/src/widgets/yaru_circular_progress_indicator_theme.dart';

import 'yaru_progress_indicator.dart';

const turn = math.pi * 2;
const _kMinCircularProgressIndicatorSize = 36.0;

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
    this.initialIndeterminatedAnimation = false,
  });

  final bool initialIndeterminatedAnimation;

  @override
  State<YaruCircularProgressIndicator> createState() =>
      _YaruCircularProgressIndicatorState();
}

class _YaruCircularProgressIndicatorState
    extends State<YaruCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool _initialAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _initialAnimation = widget.initialIndeterminatedAnimation;
    _updateControllerState();
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

  void _updateControllerState() async {
    if (widget.value == null) {
      if (widget.initialIndeterminatedAnimation) {
        _controller.duration = const Duration(milliseconds: 1000);
        await _controller.forward();
        setState(() {
          _initialAnimation = false;
        });
      } else {
        _controller.value = 0.5;
      }

      _controller.duration = const Duration(milliseconds: 6000);
      await _controller.repeat();
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
        final progress = _controller.value;
        late double barSizeProgress;
        late double pointsOpacityProgress;
        late double rotationProgress;

        if (_initialAnimation) {
          barSizeProgress =
              CurveTween(curve: Curves.easeInOut).transform(progress);
          pointsOpacityProgress = YaruClampingTween(.75, 1.0)
              .chain(CurveTween(curve: Curves.easeInOut))
              .transform(progress);
          rotationProgress = 0;
        } else {
          barSizeProgress = 1.0;
          pointsOpacityProgress = ProgressiveVisibilityTween(
            fadeOutStart: 0.1,
            fadeOutEnd: 0.2,
            fadeInStart: 0.8,
            fadeInEnd: 0.9,
          ).transform(progress);
          rotationProgress = Tween<double>(begin: 0.0, end: turn * 4)
              .chain(YaruClampingTween(0.025, 0.975))
              .chain(CurveTween(curve: Curves.easeInOutSine))
              .transform(progress);
        }

        return buildContainer(
          context,
          CustomPaint(
            painter: _IndeterminateYaruCircularProgressIndicatorPainter(
              color,
              trackColor,
              strokeWidth,
              trackStrokeWidth,
              barSizeProgress,
              pointsOpacityProgress,
              rotationProgress,
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
    this.barSizeProgress,
    this.pointsOpacityProgress,
    this.rotationProgress,
    this.textDirection,
  ) : super();

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double barSizeProgress;
  final double pointsOpacityProgress;
  final double rotationProgress;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());

    const circleThird = math.pi * 2 / 3;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final invertPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);
    const gap = 0.25;
    const align = 0;
    const sweepAngle = circleThird - gap;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var i = 0; i < 3; i++) {
      final realSweepAngle = sweepAngle * barSizeProgress;
      final startAngle = align +
          circleThird * i -
          (realSweepAngle / 2 * barSizeProgress) +
          rotationProgress;
      canvas.drawArc(
        rect,
        startAngle,
        realSweepAngle,
        false,
        strokePaint,
      );
    }

    for (var i = 0; i < 3; i++) {
      final base =
          align + circleThird * i + sweepAngle / 2 + gap / 2 + rotationProgress;
      final offset = Offset(
        math.cos(base) * radius + center.dx,
        math.sin(base) * radius + center.dy,
      );

      canvas.drawCircle(
        offset,
        7.0,
        invertPaint..color = Colors.black.withOpacity(pointsOpacityProgress),
      );

      canvas.drawCircle(
        offset,
        5.0,
        fillPaint..color = color.withOpacity(pointsOpacityProgress),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(
    _IndeterminateYaruCircularProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.barSizeProgress != barSizeProgress ||
        oldDelegate.pointsOpacityProgress != pointsOpacityProgress ||
        oldDelegate.rotationProgress != rotationProgress ||
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
