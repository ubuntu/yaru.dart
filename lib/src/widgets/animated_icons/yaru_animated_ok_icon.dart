import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import '../../constants.dart';

const _kAnimationCurve = Curves.easeInCubic;
const _kAnimationDuration = Duration(milliseconds: 500);

/// An animated Yaru ok icon, similar to [YaruIcons.ok].
///
/// See also:
///
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
///  * [YaruAnimatedOkIconWidget] if you want to play this animation manually.
class YaruAnimatedOkIcon extends YaruAnimatedIconData {
  /// An animated Yaru ok icon, similar to [YaruIcons.ok].
  const YaruAnimatedOkIcon({
    this.filled = false,
  });

  /// Determines if the icon uses a solid background, like [YaruIcons.heart_filled].
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
    return YaruAnimatedOkIconWidget(
      progress: progress,
      size: size,
      color: color,
      filled: filled,
    );
  }
}

/// An animated Yaru ok icon, similar to [YaruIcons.ok].
///
/// See also:
///
///  * [YaruAnimatedOkIcon], if you want to play this animation with a [YaruAnimatedIcon] widget.
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
class YaruAnimatedOkIconWidget extends StatelessWidget {
  /// Create an animated Yaru ok icon, similar to [YaruIcons.ok].
  const YaruAnimatedOkIconWidget({
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

  /// Determines if the icon uses a solid background, like [YaruIcons.ok_filled].
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
          painter: _YaruAnimatedOkIconPainter(
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

class _YaruAnimatedOkIconPainter extends CustomPainter {
  const _YaruAnimatedOkIconPainter(
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
    canvas.saveLayer(null, Paint());

    _paintOuterCirclePath(canvas);
    _paintCheckmark(canvas);

    canvas.restore();
  }

  void _paintOuterCirclePath(Canvas canvas) {
    canvas.drawPath(_createOuterCirclePath(), _createStrokePaint());
  }

  void _paintCheckmark(Canvas canvas) {
    if (filled) {
      canvas.drawPath(
        _createCheckmarkPath(false),
        _createFillPaint(),
      );
      canvas.drawPath(
        _createInnerCirclePath(false),
        _createFillPaint(),
      );
      canvas.drawPath(
        Path.combine(
          PathOperation.intersect,
          _createInnerCirclePath(true),
          _createCheckmarkPath(true),
        ),
        _getDiffFillPaint(),
      );
    } else {
      canvas.drawPath(
        _createCheckmarkPath(false),
        _createFillPaint(),
      );
    }
  }

  /// [long] param is used to increase the end path size for canvas clip
  Path _createCheckmarkPath(bool long) {
    final checkmark = Path();
    final start1 = Offset(size * 0.354, size * 0.477);
    final start2 = Offset(size * 0.310, size * 0.521);
    final mid1 = Offset(size * 0.521, size * 0.643);
    final mid2 = Offset(size * 0.521, size * 0.732);
    final end1 = long
        ? Offset(size * 0.895, size * 0.270)
        : Offset(size * 0.865, size * 0.299);
    final end2 = long
        ? Offset(size * 0.939, size * 0.314)
        : Offset(size * 0.892, size * 0.360);

    if (progress < 0.5) {
      final pathT = progress * 2.0;
      final drawMid1 = Offset.lerp(start1, mid1, pathT)!;
      final drawMid2 = Offset.lerp(start2, mid2, pathT)!;

      checkmark.moveTo(start1.dx, start1.dy);
      checkmark.lineTo(drawMid1.dx, drawMid1.dy);
      checkmark.lineTo(drawMid2.dx, drawMid2.dy);
      checkmark.lineTo(start2.dx, start2.dy);
      checkmark.close();
    } else {
      final pathT = (progress - 0.5) * 2.0;
      final drawEnd1 = Offset.lerp(mid1, end1, pathT)!;
      final drawEnd2 = Offset.lerp(mid2, end2, pathT)!;

      checkmark.moveTo(start1.dx, start1.dy);
      checkmark.lineTo(mid1.dx, mid1.dy);
      checkmark.lineTo(drawEnd1.dx, drawEnd1.dy);
      checkmark.lineTo(drawEnd2.dx, drawEnd2.dy);
      checkmark.lineTo(mid2.dx, mid2.dy);
      checkmark.lineTo(start2.dx, start2.dy);
      checkmark.close();
    }

    return checkmark;
  }

  Path _createOuterCirclePath() {
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

  /// [large] param is used to increase circle radius from half pain stroke for canvas clip
  Path _createInnerCirclePath(bool large) {
    final finalCircleRadius =
        (size / 2 - 1) * kTargetIconSize / kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius =
        progress < 0.5 ? 0.0 : (progress - 0.5) * 2 * finalCircleRadius;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size / 2, size / 2),
          radius: large
              ? circleRadius + (1 / (kTargetCanvasSize / size))
              : circleRadius,
        ),
      );
  }

  Paint _createFillPaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.src;
  }

  Paint _createStrokePaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / (kTargetCanvasSize / size)
      ..blendMode = BlendMode.src;
  }

  Paint _getDiffFillPaint() {
    return Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;
  }

  @override
  bool shouldRepaint(
    _YaruAnimatedOkIconPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.size != size ||
        oldDelegate.filled != filled ||
        oldDelegate.color != color;
  }
}
