import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import '../../constants.dart';
import '../../foundation/local_progress_mixin.dart';

const _kAnimationCurve = Curves.easeInQuad;
const _kAnimationDuration = Duration(milliseconds: 400);

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
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
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
    final size = this.size ?? kTargetCanvasSize;
    final color = this.color ?? Theme.of(context).colorScheme.onSurface;

    return SizedBox.square(
      dimension: size,
      child: RepaintBoundary(
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

class _YaruAnimatedNoNetworkIconPainter extends CustomPainter
    with LocalProgress {
  const _YaruAnimatedNoNetworkIconPainter(
    this.size,
    this.color,
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final Color color;
  @override
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());

    // Waves
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getWave1Path(),
      start: 0.0,
      duration: 0.4,
      paint: _getStrokePaint(),
    );
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getWave2Path(),
      start: 0.1,
      duration: 0.5,
      paint: _getStrokePaint(),
    );
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getWave3Path(),
      start: 0.2,
      duration: 0.6,
      paint: _getStrokePaint(),
    );
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getWave4Path(),
      start: 0.3,
      duration: 0.7,
      paint: _getStrokePaint(),
    );

    // Stripes
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getStripe1Path(),
      start: 0.4,
      duration: 0.6,
      paint: _getStrokePaint(),
    );
    _drawExtractedPathMetric(
      canvas: canvas,
      path: _getStripe2Path(),
      start: 0.4,
      duration: 0.6,
      paint: _getDiffStrokePaint(),
    );

    // Dot
    _drawDot(
      canvas: canvas,
      start: 0.0,
      duration: 0.5,
    );

    canvas.restore();
  }

  Path _getWave1Path() {
    return Path()
      ..moveTo(size * 0.6466471, size * 0.6155599)
      ..cubicTo(
        size * 0.6054710,
        size * 0.5812731,
        size * 0.5535823,
        size * 0.5624987,
        size * 0.5000000,
        size * 0.5625000,
      )
      ..cubicTo(
        size * 0.4464713,
        size * 0.5626250,
        size * 0.3946749,
        size * 0.5814829,
        size * 0.3535970,
        size * 0.6158040,
      );
  }

  Path _getWave2Path() {
    return Path()
      ..moveTo(size * 0.7352702, size * 0.5269368)
      ..cubicTo(
        size * 0.6704428,
        size * 0.4693235,
        size * 0.5867288,
        size * 0.4375000,
        size * 0.5000000,
        size * 0.4375000,
      )
      ..cubicTo(
        size * 0.4133234,
        size * 0.4376250,
        size * 0.3297026,
        size * 0.4695350,
        size * 0.2649740,
        size * 0.5271810,
      );
  }

  Path _getWave3Path() {
    return Path()
      ..moveTo(size * 0.8237305, size * 0.4384766)
      ..cubicTo(
        size * 0.7353761,
        size * 0.3574702,
        size * 0.6198688,
        size * 0.3125217,
        size * 0.5000000,
        size * 0.3125000,
      )
      ..cubicTo(
        size * 0.3802343,
        size * 0.3127771,
        size * 0.2649141,
        size * 0.3578946,
        size * 0.1767578,
        size * 0.4389648,
      );
  }

  Path _getWave4Path() {
    return Path()
      ..moveTo(size * 0.9121094, size * 0.3500977)
      ..cubicTo(
        size * 0.8002838,
        size * 0.2456712,
        size * 0.6530028,
        size * 0.1875615,
        size * 0.5000000,
        size * 0.1875000,
      )
      ..cubicTo(
        size * 0.3471336,
        size * 0.1879029,
        size * 0.2001027,
        size * 0.2462382,
        size * 0.08854167,
        size * 0.3507487,
      );
  }

  Path _getStripe1Path() {
    return Path()
      ..moveTo(size * 0.1666667, size * 0.1250000)
      ..lineTo(size * 0.7916667, size * 0.7500000);
  }

  Path _getStripe2Path() {
    return Path()
      ..moveTo(size * 0.19614, size * 0.09552)
      ..lineTo(size * 0.82116, size * 0.72055);
  }

  void _drawExtractedPathMetric({
    required Canvas canvas,
    required Path path,
    required double start,
    required double duration,
    required Paint paint,
  }) {
    final metric = path.computeMetrics().single;
    final drawPath = metric.extractPath(
      0,
      metric.length * computeLocalProgress(start, duration),
    );

    canvas.drawPath(drawPath, paint);
  }

  void _drawDot({
    required Canvas canvas,
    required double start,
    required double duration,
  }) {
    canvas.drawCircle(
      Offset(size * 0.5, size * 0.7916667),
      (size * 0.08333333) * computeLocalProgress(start, duration),
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
      ..strokeWidth = 1 / (kTargetCanvasSize / size)
      ..blendMode = BlendMode.src;
  }

  Paint _getDiffStrokePaint() {
    return Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / (kTargetCanvasSize / size)
      ..blendMode = BlendMode.dstOut;
  }

  @override
  bool shouldRepaint(_YaruAnimatedNoNetworkIconPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.size != size ||
        oldDelegate.color != color;
  }
}
