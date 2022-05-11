import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

const double _kMinCircularProgressIndicatorSize = 36.0;
const double _kDefaultCircularProgressStrokeWidth = 6;
const double _kDefaultLinearProgressMinHeight = 6;
const int _kIndeterminateAnimationDuration = 8000;
const Curve _kIndeterminateAnimationCurve =
    Cubic(.35, .75, .65, .25); // Kind of `Curves.slowMiddle` curve

abstract class _YaruProgressIndicator extends StatefulWidget {
  /// Creates a Yaru progress indicator.
  ///
  /// {@template yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  /// {@endtemplate}
  const _YaruProgressIndicator({
    Key? key,
    this.value,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  }) : super(key: key);

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [ProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  final String? semanticsValue;

  Color _getValueColor(BuildContext context) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class YaruLinearProgressIndicator extends _YaruProgressIndicator {
  /// Creates a Yaru linear progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruLinearProgressIndicator({
    Key? key,
    double? value,
    this.minHeight = _kDefaultLinearProgressMinHeight,
    Color? color,
    Animation<Color?>? valueColor,
    String? semanticsLabel,
    String? semanticsValue,
  })  : assert(minHeight > 0),
        super(
            key: key,
            value: value,
            color: color,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue);

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
      .chain(CurveTween(curve: _kIndeterminateAnimationCurve));
  static final Animatable<double> _speedTween = Tween(begin: -1.0, end: 1.0)
      .chain(CurveTween(curve: _kIndeterminateAnimationCurve));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration:
            const Duration(milliseconds: _kIndeterminateAnimationDuration),
        vsync: this);

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
                  widget._getValueColor(context),
                  Directionality.of(context))));
    }

    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return _buildContainer(
            context,
            ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.minHeight)),
                child: CustomPaint(
                  painter: _IndeterminateYaruLinearProgressIndicatorPainter(
                      widget._getValueColor(context),
                      _positionTween.evaluate(_controller),
                      _speedTween.evaluate(_controller).abs(),
                      Directionality.of(context)),
                )),
          );
        });
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    return widget._buildSemanticsWrapper(
        context: context,
        child: Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: widget.minHeight,
            ),
            child: child));
  }
}

class _IndeterminateYaruLinearProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruLinearProgressIndicatorPainter(
      this.color, this.position, this.speed, this.textDirection)
      : super();

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

      canvas.drawLine(Offset(x1, y), Offset(x2, y),
          _getGradientPaint(color, x1, strokeWidth, size.height, speed));
      canvas.drawCircle(Offset(x2, y), size.height / 2, fillPaint);

      // If a line overflow on the right, redraw it on the left
      if (x2 > size.width) {
        canvas.drawLine(
            Offset(x1 - size.width, y),
            Offset(x2 - size.width, y),
            _getGradientPaint(
                color, x1 - size.width, strokeWidth, size.height, speed));
        canvas.drawCircle(
            Offset(x2 - size.width, y), size.height / 2, fillPaint);
      }
    }
  }

  Paint _getGradientPaint(
      Color color, double x, double width, double height, double speed) {
    final gradient = LinearGradient(colors: [
      color.withAlpha(0),
      color.withAlpha(20 + (230 * speed).toInt()),
      color.withAlpha(150 + (100 * speed).toInt())
    ], stops: const [
      0.15,
      0.75,
      1
    ]);

    return Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(x, 0.0, width, height))
      ..strokeWidth = height
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  bool shouldRepaint(
      _IndeterminateYaruLinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.position != position ||
        oldDelegate.speed != speed ||
        oldDelegate.textDirection != textDirection;
  }
}

class _DeterminateYaruLinearProgressIndicatorPainter extends CustomPainter {
  const _DeterminateYaruLinearProgressIndicatorPainter(
      this.value, this.color, this.textDirection)
      : super();

  final double value;
  final Color color;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundHeight = size.height > 2 ? size.height - 2 : size.height;
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

    canvas.drawLine(
        Offset(backgroundHeight / 2, size.height / 2),
        Offset(size.width - backgroundHeight / 2, size.height / 2),
        backgroundPaint);
    canvas.drawLine(
        Offset(size.height / 2, size.height / 2),
        Offset((size.width - size.height / 2) * value, size.height / 2),
        strokePaint);
  }

  @override
  bool shouldRepaint(
      _DeterminateYaruLinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.textDirection != textDirection;
  }
}

class YaruCircularProgressIndicator extends _YaruProgressIndicator {
  /// Creates a Yaru circular progress indicator.
  ///
  /// {@macro yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  const YaruCircularProgressIndicator({
    Key? key,
    double? value,
    this.strokeWidth = _kDefaultCircularProgressStrokeWidth,
    Color? color,
    Animation<Color?>? valueColor,
    String? semanticsLabel,
    String? semanticsValue,
  }) : super(
            key: key,
            value: value,
            color: color,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue);

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
          .chain(CurveTween(curve: _kIndeterminateAnimationCurve));
  static final Animatable<double> _speedTween = Tween(begin: -1.0, end: 1.0)
      .chain(CurveTween(curve: _kIndeterminateAnimationCurve));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration:
            const Duration(milliseconds: _kIndeterminateAnimationDuration),
        vsync: this);

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
                  widget._getValueColor(context),
                  widget.strokeWidth,
                  Directionality.of(context))));
    }
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return _buildContainer(
              context,
              CustomPaint(
                painter: _IndeterminateYaruCircularProgressIndicatorPainter(
                    widget._getValueColor(context),
                    widget.strokeWidth,
                    _rotationTween.evaluate(_controller),
                    _speedTween.evaluate(_controller).abs(),
                    Directionality.of(context)),
              ));
        });
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    return widget._buildSemanticsWrapper(
        context: context,
        child: Container(
            constraints: const BoxConstraints(
              minWidth: _kMinCircularProgressIndicatorSize,
              minHeight: _kMinCircularProgressIndicatorSize,
            ),
            child: child));
  }
}

class _IndeterminateYaruCircularProgressIndicatorPainter extends CustomPainter {
  const _IndeterminateYaruCircularProgressIndicatorPainter(this.color,
      this.strokeWidth, this.rotationAngle, this.speed, this.textDirection)
      : super();

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
        stops: const [
          0.15,
          0.75,
          1
        ]);

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
          Offset(math.cos(startAngle) * radius + center.dx,
              math.sin(startAngle) * radius + center.dy),
          strokeWidth / 2,
          fillPaint);
    }
  }

  @override
  bool shouldRepaint(
      _IndeterminateYaruCircularProgressIndicatorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.speed != speed ||
        oldDelegate.textDirection != textDirection;
  }
}

class _DeterminateYaruCircularProgressIndicatorPainter extends CustomPainter {
  const _DeterminateYaruCircularProgressIndicatorPainter(
      this.value, this.color, this.width, this.textDirection)
      : super();

  final double value;
  final Color color;
  final double width;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    const startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * value;
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
      _DeterminateYaruCircularProgressIndicatorPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.width != width ||
        oldDelegate.textDirection != textDirection;
  }
}
