import 'package:flutter/material.dart';
import 'package:yaru/src/widgets/yaru_linear_progress_indicator_theme.dart';

import 'yaru_progress_indicator.dart';

const _kIndeterminateAnimationDuration = 8000;
const _kDefaultStrokeWidth = 4.0;
const _kIndeterminateAnimationCurve = Curves.easeInOutSine;
const _kDefaultTrackColorOpacity = 0.25;
const _kIndeterminateAnimationCycles = 7.0;

class YaruLinearProgressIndicator extends YaruProgressIndicator {
  /// Creates a Yaru linear progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruLinearProgressIndicator({
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
      duration: const Duration(milliseconds: _kIndeterminateAnimationDuration),
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
    final trackColor = widget.trackValueColor?.value ??
        widget.trackColor ??
        progressTheme?.trackColor ??
        color.withOpacity(_kDefaultTrackColorOpacity);
    final strokeWidth = widget.strokeWidth ??
        progressTheme?.strokeWidth ??
        _kDefaultStrokeWidth;
    final trackStrokeWidth = widget.trackStrokeWidth ??
        progressTheme?.trackStrokeWidth ??
        strokeWidth;

    Widget buildContainer(BuildContext context, Widget child) {
      return widget.buildSemanticsWrapper(
        context: context,
        child: Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: strokeWidth,
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
        final spacingProgress = 1 -
            Tween<double>(begin: -1.0, end: 1.0)
                .chain(CurveTween(curve: _kIndeterminateAnimationCurve))
                .transform(progress)
                .abs();
        final trackProgress =
            Tween<double>(begin: 0.0, end: _kIndeterminateAnimationCycles)
                .chain(CurveTween(curve: _kIndeterminateAnimationCurve))
                .transform(progress);

        return buildContainer(
          context,
          ClipRect(
            child: CustomPaint(
              painter: _IndeterminateYaruLinearProgressIndicatorPainter(
                color,
                strokeWidth,
                spacingProgress,
                trackProgress,
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
    this.strokeWidth,
    this.spacingProgress,
    this.trackProgress,
    this.textDirection,
  ) : super();

  final Color color;
  final double strokeWidth;
  final double spacingProgress;
  final double trackProgress;
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

    canvas.drawLine(
      Offset(strokeWidth / 2, y),
      Offset(size.width - strokeWidth / 2, y),
      strokePaint,
    );

    final points = <Offset>[];
    for (var i = -1; i <= 1; i++) {
      final x = size.width / 2 +
          50 * i +
          (size.width / 3 - 50) * spacingProgress * i +
          size.width * realTrackPosition;
      points.add(
        Offset(x < size.width ? x : x - size.width, y),
      );
    }

    for (final point in points) {
      final gap = size.width / 20 * spacingProgress;
      canvas.drawLine(
        point + Offset(-gap / 2, 0),
        point + Offset(gap / 2, 0),
        invertStrokePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(
    _IndeterminateYaruLinearProgressIndicatorPainter oldDelegate,
  ) {
    return true;
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
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.textDirection != textDirection;
  }
}
