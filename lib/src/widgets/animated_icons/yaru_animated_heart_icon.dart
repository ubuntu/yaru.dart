import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import '../../constants.dart';
import '../../foundation/local_progress_mixin.dart';

const _kAnimationCurve = Curves.easeInOutCubic;
const _kAnimationDuration = Duration(milliseconds: 600);

/// An animated Yaru heart icon, similar to [YaruIcons.heart].
///
/// See also:
///
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
///  * [YaruAnimatedHeartIconWidget] if you want to play this animation manually.
class YaruAnimatedHeartIcon extends YaruAnimatedIconData {
  /// An animated Yaru heart icon, similar to [YaruIcons.heart].
  const YaruAnimatedHeartIcon({
    this.filled,
  });

  /// Determines if the icon uses a solid background, like [YaruIcons.heart_filled].
  /// Defaults to false.
  final bool? filled;

  @override
  Widget build(
    BuildContext context,
    Animation<double> progress,
    double? size,
    Color? color,
  ) {
    return YaruAnimatedHeartIconWidget(
      progress: progress,
      size: size,
      filled: filled,
      color: color,
    );
  }

  @override
  Duration get defaultDuration => _kAnimationDuration;

  @override
  Curve get defaultCurve => _kAnimationCurve;
}

/// An animated Yaru heart icon, similar to [YaruIcons.heart].
///
/// See also:
///
///  * [YaruAnimatedHeartIcon], if you want to play this animation with a [YaruAnimatedIcon] widget.
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
class YaruAnimatedHeartIconWidget extends StatelessWidget {
  /// Create an animated Yaru heart icon, similar to [YaruIcons.heart].
  const YaruAnimatedHeartIconWidget({
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

  /// Determines if the icon uses a solid background, like [YaruIcons.heart_filled].
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
          painter: _YaruAnimatedHeartIconPainter(
            size,
            color,
            filled,
            progress.value,
          ),
        ),
      ),
    );
  }
}

class _YaruAnimatedHeartIconPainter extends CustomPainter with LocalProgress {
  const _YaruAnimatedHeartIconPainter(
    this.size,
    this.color,
    this.filled,
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final Color color;
  final bool filled;
  @override
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < .5) {
      final metric = _getHeartPath().computeMetrics().single;
      final localProgress = computeLocalProgress(0, .5);
      final drawPath = metric.extractPath(
        metric.length / 2 - metric.length / 2 * localProgress,
        metric.length / 2 + metric.length / 2 * localProgress,
      );

      canvas.drawPath(
        drawPath,
        _getStrokePaint(),
      );
    } else {
      final localProgress = computeLocalProgress(.5, .5);
      final scale = localProgress < .5
          ? 1 - .25 * computeLocalProgress(.5, .25)
          : .75 + .25 * computeLocalProgress(.75, .25);
      canvas.drawPath(
        _getHeartPath(scale: scale),
        _getStrokePaint(),
      );

      if (filled && localProgress >= .5) {
        canvas.drawPath(
          _getHeartPath(scale: computeLocalProgress(.75, .25)),
          _getFillPaint(),
        );
      }
    }
  }

  Path _getHeartPath({double scale = 1.0}) {
    assert(scale >= 0.0 && scale <= 1.0);
    final localSize = size * scale;

    return Path()
      ..moveTo(
        localSize * 0.5000696 + (size - localSize) / 2,
        localSize * 0.2653214 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.4252717 + (size - localSize) / 2,
        localSize * 0.2038911 + (size - localSize) / 2,
        localSize * 0.3562770 + (size - localSize) / 2,
        localSize * 0.1784415 + (size - localSize) / 2,
        localSize * 0.3001936 + (size - localSize) / 2,
        localSize * 0.1904627 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.2407755 + (size - localSize) / 2,
        localSize * 0.2031987 + (size - localSize) / 2,
        localSize * 0.2012291 + (size - localSize) / 2,
        localSize * 0.2556057 + (size - localSize) / 2,
        localSize * 0.1907196 + (size - localSize) / 2,
        localSize * 0.3239365 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.1697006 + (size - localSize) / 2,
        localSize * 0.4605983 + (size - localSize) / 2,
        localSize * 0.2522089 + (size - localSize) / 2,
        localSize * 0.6683053 + (size - localSize) / 2,
        localSize * 0.4883975 + (size - localSize) / 2,
        localSize * 0.8454960 + (size - localSize) / 2,
      )
      ..lineTo(
        localSize * 0.5000696 + (size - localSize) / 2,
        localSize * 0.8542308 + (size - localSize) / 2,
      )
      ..lineTo(
        localSize * 0.5117417 + (size - localSize) / 2,
        localSize * 0.8454960 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.7479304 + (size - localSize) / 2,
        localSize * 0.6683053 + (size - localSize) / 2,
        localSize * 0.8304387 + (size - localSize) / 2,
        localSize * 0.4605982 + (size - localSize) / 2,
        localSize * 0.8094196 + (size - localSize) / 2,
        localSize * 0.3239365 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.7989101 + (size - localSize) / 2,
        localSize * 0.2556057 + (size - localSize) / 2,
        localSize * 0.7593637 + (size - localSize) / 2,
        localSize * 0.2031987 + (size - localSize) / 2,
        localSize * 0.6999455 + (size - localSize) / 2,
        localSize * 0.1904627 + (size - localSize) / 2,
      )
      ..cubicTo(
        localSize * 0.6438623 + (size - localSize) / 2,
        localSize * 0.1784415 + (size - localSize) / 2,
        localSize * 0.5748676 + (size - localSize) / 2,
        localSize * 0.2038911 + (size - localSize) / 2,
        localSize * 0.5000696 + (size - localSize) / 2,
        localSize * 0.2653214 + (size - localSize) / 2,
      )
      ..close();
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

  @override
  bool shouldRepaint(_YaruAnimatedHeartIconPainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.color != color ||
        oldDelegate.filled != filled ||
        oldDelegate.progress != progress;
  }
}
