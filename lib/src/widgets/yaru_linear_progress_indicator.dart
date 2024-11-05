import 'package:flutter/material.dart';
import 'package:yaru/src/foundation/yaru_tween.dart';
import 'package:yaru/src/widgets/yaru_linear_progress_indicator_theme.dart';

import 'yaru_progress_indicator.dart';

class YaruLinearProgressIndicator extends YaruProgressIndicator {
  /// Creates a Yaru linear progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruLinearProgressIndicator({
    super.key,
    super.value,
    this.minHeight,
    super.strokeWidth,
    super.trackStrokeWidth,
    super.color,
    super.valueColor,
    super.trackColor,
    super.trackValueColor,
    super.semanticsLabel,
    super.semanticsValue,
  }) : assert(minHeight == null || minHeight > 0);

  /// {@macro yaru.widget.YaruProgressIndicator.strokeWidth}
  @Deprecated('Use [strokeWidth] instead.')
  final double? minHeight;

  @override
  State<YaruLinearProgressIndicator> createState() =>
      _YaruLinearProgressIndicatorState();
}

class _YaruLinearProgressIndicatorState
    extends State<YaruLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(YaruLinearProgressIndicator oldWidget) {
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
    final progressTheme = YaruLinearProgressIndicatorTheme.of(context);

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
    final strokeWidth = widget.strokeWidth ??
        // ignore: deprecated_member_use_from_same_package
        widget.minHeight ??
        progressTheme?.strokeWidth ??
        kDefaultStrokeWidth;
    final trackStrokeWidth = widget.trackStrokeWidth ??
        progressTheme?.trackStrokeWidth ??
        widget.computeDefaultTrackSize(strokeWidth);
    const dotsRadius = 5.0;

    Widget buildContainer(BuildContext context, Widget child) {
      return widget.buildSemanticsWrapper(
        context: context,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: dotsRadius * 2,
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
          painter: _DeterminateYaruLinearProgressIndicatorPainter(
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
        final pointsOpacityProgress = ProgressiveVisibilityTween(
          fadeOutStart: 0.1,
          fadeOutEnd: 0.2,
          fadeInStart: 0.8,
          fadeInEnd: 0.9,
        ).transform(progress);
        final pointsSpacingProgress = 1 -
            Tween<double>(begin: -1.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOutSine))
                .transform(progress)
                .abs();
        final trackProgress = Tween<double>(begin: 0.0, end: 6.0)
            .chain(CurveTween(curve: Curves.easeInOutSine))
            .transform(progress);

        return buildContainer(
          context,
          ClipRect(
            child: CustomPaint(
              painter: _IndeterminateYaruLinearProgressIndicatorPainter(
                color,
                trackColor,
                strokeWidth,
                dotsRadius,
                pointsSpacingProgress,
                trackProgress,
                pointsOpacityProgress,
                Directionality.of(context),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IndeterminateYaruLinearProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruLinearProgressIndicatorPainter(
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.dotsRadius,
    this.pointsSpacingProgress,
    this.trackProgress,
    this.dotsOpacityProgress,
    this.textDirection,
  ) : super();

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double dotsRadius;
  final double pointsSpacingProgress;
  final double trackProgress;
  final double dotsOpacityProgress;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());

    final realTrackPosition = trackProgress - trackProgress.truncate();

    final y = size.height / 2;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final invertStrokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.dstOut;
    final fillPaint = Paint()
      ..color = color.withOpacity(dotsOpacityProgress)
      ..style = PaintingStyle.fill;
    final invertFillPaint = Paint()
      ..color = Colors.black.withOpacity(dotsOpacityProgress)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawLine(
      Offset(strokeWidth / 2, y),
      Offset(size.width - strokeWidth / 2, y),
      strokePaint,
    );

    final points = <Offset>[];
    for (var i = -1; i <= 1; i++) {
      final x = size.width / 2 +
          50 * i +
          (size.width / 3 - 50) * pointsSpacingProgress * i +
          size.width * realTrackPosition;
      points.add(
        Offset(x < size.width ? x : x - size.width, y),
      );
    }

    for (final point in points) {
      final gap = size.width / 20 * pointsSpacingProgress;
      canvas.drawLine(
        point + Offset(-gap / 2, 0),
        point + Offset(gap / 2, 0),
        invertStrokePaint,
      );
      canvas.drawCircle(
        point,
        dotsRadius + 2,
        invertFillPaint,
      );
      canvas.drawCircle(
        point,
        dotsRadius,
        fillPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(
    _IndeterminateYaruLinearProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.trackProgress != trackProgress ||
        oldDelegate.dotsOpacityProgress != dotsOpacityProgress ||
        oldDelegate.textDirection != textDirection;
  }
}

class _DeterminateYaruLinearProgressIndicatorPainter extends CustomPainter {
  const _DeterminateYaruLinearProgressIndicatorPainter(
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
    final realStrokeWidth = size.height;
    final realTrackStrokeWidth =
        trackStrokeWidth * (realStrokeWidth / strokeWidth);
    final y = size.height / 2;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = realStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final trackStrokePaint = Paint()
      ..color = trackColor
      ..strokeWidth = realTrackStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    canvas.drawLine(
      Offset(realTrackStrokeWidth / 2, y),
      Offset(size.width - realTrackStrokeWidth / 2, y),
      trackStrokePaint,
    );

    if (size.width * revisedValue > size.height) {
      canvas.drawLine(
        Offset(y, y),
        Offset((size.width - y) * revisedValue, y),
        strokePaint,
      );
    } else if (revisedValue > 0) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(y, y), y, fillPaint);
    }
  }

  @override
  bool shouldRepaint(
    _DeterminateYaruLinearProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.textDirection != textDirection;
  }
}
