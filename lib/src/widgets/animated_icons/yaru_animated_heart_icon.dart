import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import '../../constants.dart';
import 'yaru_single_path_trace_painter.dart';

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

class _YaruAnimatedHeartIconPainter extends YaruSinglePathTracePainter {
  _YaruAnimatedHeartIconPainter(
    super.size,
    super.color,
    super.filled,
    super.progress,
  );

  @override
  Path getPath() {
    return Path()
      ..moveTo(
        size * 0.5000696,
        size * 0.2653214,
      )
      ..cubicTo(
        size * 0.4252717,
        size * 0.2038911,
        size * 0.3562770,
        size * 0.1784415,
        size * 0.3001936,
        size * 0.1904627,
      )
      ..cubicTo(
        size * 0.2407755,
        size * 0.2031987,
        size * 0.2012291,
        size * 0.2556057,
        size * 0.1907196,
        size * 0.3239365,
      )
      ..cubicTo(
        size * 0.1697006,
        size * 0.4605983,
        size * 0.2522089,
        size * 0.6683053,
        size * 0.4883975,
        size * 0.8454960,
      )
      ..lineTo(
        size * 0.5000696,
        size * 0.8542308,
      )
      ..lineTo(
        size * 0.5117417,
        size * 0.8454960,
      )
      ..cubicTo(
        size * 0.7479304,
        size * 0.6683053,
        size * 0.8304387,
        size * 0.4605982,
        size * 0.8094196,
        size * 0.3239365,
      )
      ..cubicTo(
        size * 0.7989101,
        size * 0.2556057,
        size * 0.7593637,
        size * 0.2031987,
        size * 0.6999455,
        size * 0.1904627,
      )
      ..cubicTo(
        size * 0.6438623,
        size * 0.1784415,
        size * 0.5748676,
        size * 0.2038911,
        size * 0.5000696,
        size * 0.2653214,
      )
      ..close();
  }
}
