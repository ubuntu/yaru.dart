import 'package:flutter/material.dart';

import 'yaru_progress_indicator.dart';

const double _kDefaultLinearProgressMinHeight = 6;

class YaruLinearProgressIndicator extends YaruProgressIndicator {
  /// Creates a Yaru linear progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruLinearProgressIndicator({
    super.key,
    super.value,
    this.minHeight = _kDefaultLinearProgressMinHeight,
    super.color,
    super.valueColor,
    super.semanticsLabel,
    super.semanticsValue,
  }) : assert(minHeight > 0);

  /// The minimum height of the line used to draw the linear indicator (default: 6).
  final double minHeight;

  @override
  _YaruLinearProgressIndicatorState createState() =>
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
    if (widget.value != null) {
      return _buildContainer(
        context,
        CustomPaint(
          painter: _DeterminateYaruLinearProgressIndicatorPainter(
            widget.value!,
            widget.getValueColor(context),
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
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.minHeight)),
            child: CustomPaint(
              painter: _IndeterminateYaruLinearProgressIndicatorPainter(
                widget.getValueColor(context),
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

  Widget _buildContainer(BuildContext context, Widget child) {
    return widget.buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: widget.minHeight,
        ),
        child: child,
      ),
    );
  }
}

class _IndeterminateYaruLinearProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruLinearProgressIndicatorPainter(
    this.color,
    this.position,
    this.speed,
    this.textDirection,
  ) : super();

  final Color color;
  final double position;
  final double speed;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final realPosition = position - position.truncate();
    final strokeWidth = size.width / 6;
    final y = size.height / 2;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    for (var i = 0; i < 3; i++) {
      final x1 = size.width * realPosition +
          (strokeWidth * i / 2 + (strokeWidth * i * speed));
      final x2 = size.width * realPosition +
          strokeWidth +
          (strokeWidth * i / 2 + (strokeWidth * i * speed));

      canvas.drawLine(
        Offset(x1, y),
        Offset(x2, y),
        _getGradientPaint(color, x1, strokeWidth, size.height, speed),
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
            strokeWidth,
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
        color.withAlpha(150 + (100 * speed).toInt())
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
    this.textDirection,
  ) : super();

  final double value;
  final Color color;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final revisedValue = value >= 0 && value <= 1
        ? value
        : value < 0
            ? 0
            : 1;
    final candidateBackgroundHeight = (size.height / 3 * 2).truncate();
    final backgroundHeight =
        (candidateBackgroundHeight + (candidateBackgroundHeight.isEven ? 0 : 1))
            .toDouble();

    final backgroundPaint = Paint()
      ..color = color.withOpacity(.25)
      ..strokeWidth = backgroundHeight
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (textDirection == TextDirection.rtl) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    final y = size.height / 2;

    canvas.drawLine(
      Offset(backgroundHeight / 2, y),
      Offset(size.width - backgroundHeight / 2, y),
      backgroundPaint,
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
