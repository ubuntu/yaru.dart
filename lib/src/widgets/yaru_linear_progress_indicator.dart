import 'package:flutter/material.dart';
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
  static final Animatable<double> _positionTween = Tween(begin: 0.0, end: 6.0)
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
        return buildContainer(
          context,
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(strokeWidth)),
            child: CustomPaint(
              painter: _IndeterminateYaruLinearProgressIndicatorPainter(
                color,
                trackColor,
                strokeWidth,
                trackStrokeWidth,
                _positionTween.evaluate(_controller),
                _speedTween.evaluate(_controller).abs(),
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
    this.trackStrokeWidth,
    this.position,
    this.speed,
    this.textDirection,
  ) : super();

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double position;
  final double speed;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final realPosition = position - position.truncate();
    final realStrokeWidth = size.height;
    final realTrackStrokeWidth =
        trackStrokeWidth * (realStrokeWidth / strokeWidth);
    final strokeLength = size.width / 6;
    final y = size.height / 2;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
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

    for (var i = 0; i < 3; i++) {
      final x1 = size.width * realPosition +
          (strokeLength * i / 2 + (strokeLength * i * speed));
      final x2 = size.width * realPosition +
          size.width / 6 +
          (strokeLength * i / 2 + (strokeLength * i * speed));

      canvas.drawLine(
        Offset(x1, y),
        Offset(x2, y),
        _getGradientPaint(color, x1, strokeLength, size.height, speed),
      );
      canvas.drawCircle(Offset(x2, y), size.height / 2, fillPaint);

      // If a line overflow on the right, redraw it on the left
      if (x2 > size.width) {
        canvas.drawLine(
          Offset(x1 - size.width, y),
          Offset(x2 - size.width, y),
          _getGradientPaint(
            color,
            x1 - size.width,
            strokeLength,
            size.height,
            speed,
          ),
        );
        canvas.drawCircle(
          Offset(x2 - size.width, y),
          size.height / 2,
          fillPaint,
        );
      }
    }
  }

  Paint _getGradientPaint(
    Color color,
    double x,
    double width,
    double height,
    double speed,
  ) {
    final gradient = LinearGradient(
      colors: [
        color.withAlpha(0),
        color.withAlpha(20 + (230 * speed).toInt()),
        color.withAlpha(150 + (100 * speed).toInt()),
      ],
      stops: const [0.15, 0.75, 1],
    );

    return Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(x, 0.0, width, height))
      ..strokeWidth = height
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  bool shouldRepaint(
    _IndeterminateYaruLinearProgressIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.position != position ||
        oldDelegate.speed != speed ||
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
