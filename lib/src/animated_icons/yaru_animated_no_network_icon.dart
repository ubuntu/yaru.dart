import 'package:flutter/material.dart';

import '../../yaru_icons.dart';

const _kTargetCanvasSize = 24.0;
const _kAnimationCurve = Curves.easeInQuart;
const _kAnimationDuration = Duration(milliseconds: 600);

/// An animated Yaru no network icon, similar to [YaruIcons.network_wireless] and [YaruIcons.network_wireless_disabled].
///
/// See also:
///
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
///  * [YaruAnimatedNoNetworkIconWidget] if you want to play this animation manually.
class YaruAnimatedNoNetworkIcon extends YaruAnimatedIconData {
  /// An animated Yaru no network icon, similar to [YaruIcons.network_wireless] and [YaruIcons.network_wireless_disabled].
  const YaruAnimatedNoNetworkIcon();

  @override
  Duration get defaultDuration => _kAnimationDuration;

  @override
  Curve get defaultCurve => _kAnimationCurve;

  @override
  Widget build(
    BuildContext context,
    Animation<double> progress,
    double? size,
    Color? color,
  ) {
    return YaruAnimatedNoNetworkIconWidget(
      progress: progress,
      size: size,
      color: color,
    );
  }
}

/// An animated Yaru no network icon, similar to [YaruIcons.network_wireless] and [YaruIcons.network_wireless_disabled].
///
/// See also:
///
///  * [YaruAnimatedNoNetworkIcon], if you want to play this animation with a [YaruAnimatedIcon] widget.
class YaruAnimatedNoNetworkIconWidget extends StatelessWidget {
  /// Create an animated Yaru no network icon, similar to [YaruIcons.network_wireless] and [YaruIcons.network_wireless_disabled].
  const YaruAnimatedNoNetworkIconWidget({
    super.key,
    this.size,
    this.color,
    required this.progress,
  });

  /// Determines the icon canvas size.
  /// To fit the original Yaru icon, the icon will be slightly smaller (20.0 on a 24.0 canvas).
  /// Defaults to 24.0 as the original Yaru icon.
  final double? size;

  /// Color used to draw the icon.
  /// If null, defaults to colorScheme.onSurface.
  final Color? color;

  /// The animation progress for the animated icon.
  /// The value is clamped to be between 0 and 1.
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? _kTargetCanvasSize;
    final color = this.color ?? Theme.of(context).colorScheme.onSurface;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _YaruAnimatedNoNetworkIconPainter(
            size,
            color,
            progress.value,
          ),
        ),
      ),
    );
  }
}

class _YaruAnimatedNoNetworkIconPainter extends CustomPainter {
  const _YaruAnimatedNoNetworkIconPainter(
    this.size,
    this.color,
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());

    _drawExtractedPathMetric(canvas, _getWave1Path(), 0, .4);
    _drawExtractedPathMetric(canvas, _getWave2Path(), 0.1, .5);
    _drawExtractedPathMetric(canvas, _getWave3Path(), 0.2, .6);
    _drawExtractedPathMetric(canvas, _getWave4Path(), 0.3, .7);
    _drawExtractedPathMetric(canvas, _getStripe1Path(), .4, .6);

    _drawStripe2Diff(canvas);

    _drawDot(canvas);

    canvas.restore();
  }

  Path _getWave1Path() {
    final wave = Path();
    wave.moveTo(size * 0.6466471, size * 0.6155599);
    wave.cubicTo(
      size * 0.6054710,
      size * 0.5812731,
      size * 0.5535823,
      size * 0.5624987,
      size * 0.5000000,
      size * 0.5625000,
    );
    wave.cubicTo(
      size * 0.4464713,
      size * 0.5626250,
      size * 0.3946749,
      size * 0.5814829,
      size * 0.3535970,
      size * 0.6158040,
    );

    return wave;
  }

  Path _getWave2Path() {
    final wave = Path();
    wave.moveTo(size * 0.7352702, size * 0.5269368);
    wave.cubicTo(
      size * 0.6704428,
      size * 0.4693235,
      size * 0.5867288,
      size * 0.4375000,
      size * 0.5000000,
      size * 0.4375000,
    );
    wave.cubicTo(
      size * 0.4133234,
      size * 0.4376250,
      size * 0.3297026,
      size * 0.4695350,
      size * 0.2649740,
      size * 0.5271810,
    );

    return wave;
  }

  Path _getWave3Path() {
    final wave = Path();
    wave.moveTo(size * 0.8237305, size * 0.4384766);
    wave.cubicTo(
      size * 0.7353761,
      size * 0.3574702,
      size * 0.6198688,
      size * 0.3125217,
      size * 0.5000000,
      size * 0.3125000,
    );
    wave.cubicTo(
      size * 0.3802343,
      size * 0.3127771,
      size * 0.2649141,
      size * 0.3578946,
      size * 0.1767578,
      size * 0.4389648,
    );

    return wave;
  }

  Path _getWave4Path() {
    final wave = Path();
    wave.moveTo(size * 0.9121094, size * 0.3500977);
    wave.cubicTo(
      size * 0.8002838,
      size * 0.2456712,
      size * 0.6530028,
      size * 0.1875615,
      size * 0.5000000,
      size * 0.1875000,
    );
    wave.cubicTo(
      size * 0.3471336,
      size * 0.1879029,
      size * 0.2001027,
      size * 0.2462382,
      size * 0.08854167,
      size * 0.3507487,
    );

    return wave;
  }

  Path _getStripe1Path() {
    final stripe = Path();
    stripe.moveTo(size * 0.1666667, size * 0.1250000);
    stripe.lineTo(size * 0.7916667, size * 0.7500000);

    return stripe;
  }

  Path _getStripe2Path() {
    final start = Offset(size * 0.19614, size * 0.09552);
    final end = Offset(size * 0.82116, size * 0.72055);

    final localProgress = _computeLocalProgress(.4, .6);

    final drawEnd = Offset.lerp(start, end, localProgress)!;

    final stripe2 = Path();
    stripe2.moveTo(start.dx, start.dy);
    stripe2.lineTo(drawEnd.dx, drawEnd.dy);

    return stripe2;
  }

  void _drawExtractedPathMetric(
    Canvas canvas,
    Path path,
    double start,
    double duration,
  ) {
    final metric = path.computeMetrics().single;
    final drawPath = metric.extractPath(
      0,
      metric.length * _computeLocalProgress(start, duration),
    );

    canvas.drawPath(drawPath, _getStrokePaint());
  }

  void _drawStripe2Diff(Canvas canvas) {
    canvas.drawPath(
      _getStripe2Path(),
      _getDiffStrokePaint(),
    );
  }

  void _drawDot(Canvas canvas) {
    canvas.drawCircle(
      Offset(size * 0.5, size * 0.7916667),
      (size * 0.08333333) * _computeLocalProgress(0, .1),
      _getFillPaint(),
    );
  }

  Paint _getFillPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..blendMode = BlendMode.src;
  }

  Paint _getStrokePaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1 / (_kTargetCanvasSize / size)
      ..blendMode = BlendMode.src;
  }

  Paint _getDiffStrokePaint() {
    return Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / (_kTargetCanvasSize / size)
      ..blendMode = BlendMode.dstOut;
  }

  double _computeLocalProgress(double start, double duration) {
    assert(start >= 0.0 && start <= 1.0);
    assert(duration >= 0.0 && duration <= 1.0);
    assert(start + duration <= 1.0);

    final localProgress =
        progress >= start ? (progress - start) * (1.0 / duration) : 0.0;

    return localProgress < 1.0 ? localProgress : 1.0;
  }

  @override
  bool shouldRepaint(_YaruAnimatedNoNetworkIconPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.size != size ||
        oldDelegate.color != color;
  }
}
