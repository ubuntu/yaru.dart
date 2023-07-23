import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import '../../constants.dart';
import '../../foundation/canvas_extension.dart';

const _kAnimationCurve = Curves.easeInOutCubic;
const _kAnimationDuration = Duration(milliseconds: 500);

/// An animated Yaru compass icon, similar to [YaruIcons.compass].
///
/// See also:
///
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
///  * [YaruAnimatedCompassIconWidget] if you want to play this animation manually.
class YaruAnimatedCompassIcon extends YaruAnimatedIconData {
  /// An animated Yaru compass icon, similar to [YaruIcons.compass].
  const YaruAnimatedCompassIcon({
    this.filled,
  });

  /// Determines if the icon uses a solid background, like [YaruIcons.compass_filled].
  /// Defaults to false.
  final bool? filled;

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
    return YaruAnimatedCompassIconWidget(
      progress: progress,
      size: size,
      color: color,
      filled: filled,
    );
  }
}

/// An animated Yaru compass icon, similar to [YaruIcons.compass].
///
/// See also:
///
///  * [YaruAnimatedCompassIcon], if you want to play this animation with a [YaruAnimatedIcon] widget.
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
class YaruAnimatedCompassIconWidget extends StatelessWidget {
  /// Create an animated Yaru compass icon, similar to [YaruIcons.compass].
  const YaruAnimatedCompassIconWidget({
    super.key,
    this.size,
    this.filled,
    this.color,
    required this.progress,
  });

  /// Determines the icon canvas size.
  /// To fit the original Yaru icon, the icon will be slightly smaller (20.0 on a 24.0 canvas).
  /// Defaults to 24.0 as the original Yaru icon.
  final double? size;

  /// Determines if the icon uses a solid background, like [YaruIcons.compass_filled].
  /// Defaults to false.
  final bool? filled;

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
    final filled = this.filled != null ? this.filled! : false;

    return SizedBox.square(
      dimension: size,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _YaruAnimatedCompassIconPainter(
            size,
            filled,
            color,
            progress.value,
          ),
        ),
      ),
    );
  }
}

class _YaruAnimatedCompassIconPainter extends CustomPainter {
  const _YaruAnimatedCompassIconPainter(
    this.size,
    this.filled,
    this.color,
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final bool filled;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _paintNeedle(canvas);
    _paintOuterCirclePath(canvas);
  }

  void _paintNeedle(Canvas canvas) {
    canvas.paintRotated(
      center: Offset(size / 2, size / 2),
      angle: progress,
      paint: (canvas) {
        canvas.drawPath(
          filled
              ? Path.combine(
                  PathOperation.xor,
                  _getInnerCirclePath(),
                  _getNeedlePath(),
                )
              : _getNeedlePath(),
          _getFillPaint(),
        );
      },
    );
  }

  void _paintOuterCirclePath(Canvas canvas) {
    canvas.drawPath(_getOuterCirclePath(), _getStrokePaint());
  }

  Path _getNeedlePath() {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(size * 0.7209583, size * 0.2790417)
      ..cubicTo(
        size * 0.6298333,
        size * 0.3122500,
        size * 0.5233333,
        size * 0.3662917,
        size * 0.4650000,
        size * 0.3970417,
      )
      ..cubicTo(
        size * 0.4503075,
        size * 0.4042311,
        size * 0.4372138,
        size * 0.4143065,
        size * 0.4265000,
        size * 0.4266667,
      )
      ..cubicTo(
        size * 0.4142177,
        size * 0.4373476,
        size * 0.4042009,
        size * 0.4503821,
        size * 0.3970417,
        size * 0.4650000,
      )
      ..cubicTo(
        size * 0.3662917,
        size * 0.5233333,
        size * 0.3122500,
        size * 0.6298333,
        size * 0.2790417,
        size * 0.7209583,
      )
      ..cubicTo(
        size * 0.3722083,
        size * 0.6870417,
        size * 0.4827917,
        size * 0.6307917,
        size * 0.5401250,
        size * 0.6004167,
      )
      ..cubicTo(
        size * 0.5527302,
        size * 0.5934542,
        size * 0.5640017,
        size * 0.5843128,
        size * 0.5734167,
        size * 0.5734167,
      )
      ..cubicTo(
        size * 0.5843120,
        size * 0.5640333,
        size * 0.5934540,
        size * 0.5527892,
        size * 0.6004167,
        size * 0.5402083,
      )
      ..cubicTo(
        size * 0.6307917,
        size * 0.4828750,
        size * 0.6870417,
        size * 0.3722083,
        size * 0.7209583,
        size * 0.2790417,
      )
      ..close()
      ..addOval(
        Rect.fromCenter(
          center: Offset(size / 2, size / 2),
          width: _scale(2),
          height: _scale(2),
        ),
      );
  }

  Path _getOuterCirclePath() {
    final finalCircleRadius =
        (size / 2 - 1) * kTargetIconSize / kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius = progress < 0.5
        ? finalCircleRadius - finalCircleRadius * 0.25 * progress
        : finalCircleRadius * 0.75 + finalCircleRadius * 0.25 * progress;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size / 2, size / 2),
          radius: circleRadius,
        ),
      );
  }

  Path _getInnerCirclePath() {
    final finalCircleRadius =
        (size / 2 - 1) * kTargetIconSize / kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius =
        progress < 0.5 ? 0.0 : (progress - 0.5) * 2 * finalCircleRadius;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size / 2, size / 2),
          radius: circleRadius,
        ),
      );
  }

  double _scale(double value) {
    return value / kTargetCanvasSize * size;
  }

  Paint _getFillPaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.src;
  }

  Paint _getStrokePaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _scale(1)
      ..blendMode = BlendMode.src;
  }

  @override
  bool shouldRepaint(
    _YaruAnimatedCompassIconPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.size != size ||
        oldDelegate.filled != filled ||
        oldDelegate.color != color;
  }
}
