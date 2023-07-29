import 'package:flutter/material.dart';

import '../../../yaru_icons.dart';
import 'yaru_single_path_trace_painter.dart';

const _kAnimationCurve = Curves.easeInOutCubic;
const _kAnimationDuration = Duration(milliseconds: 600);
const _kTargetCanvasSize = 24.0;

/// An animated Yaru star icon, similar to [YaruIcons.star].
///
/// See also:
///
///  * [YaruAnimatedIcon], a widget who play a Yaru icon animation.
///  * [YaruAnimatedStarIconWidget] if you want to play this animation manually.
class YaruAnimatedStarIcon extends YaruAnimatedIconData {
  /// An animated Yaru star icon, similar to [YaruIcons.star].
  const YaruAnimatedStarIcon({
    this.filled,
    this.fillSize,
  });

  /// Determines if the icon uses a solid background, like [YaruIcons.star_filled].
  /// Defaults to false.
  final bool? filled;

  /// Determines the filled part size, needs [filled] to be true.
  /// Ex: use 0.5 to looks like [YaruIcons.star_semi_filled].
  final double? fillSize;

  @override
  Widget build(
    BuildContext context,
    Animation<double> progress,
    double? size,
    Color? color,
  ) {
    return YaruAnimatedStarIconWidget(
      progress: progress,
      size: size,
      filled: filled,
      fillSize: fillSize,
      color: color,
    );
  }

  @override
  Duration get defaultDuration => _kAnimationDuration;

  @override
  Curve get defaultCurve => _kAnimationCurve;
}

/// An animated Yaru star icon, similar to [YaruIcons.star].
///
/// See also:
///
///  * [YaruAnimatedStarIcon], if you want to play this animation with a [YaruAnimatedIcon] widget.
class YaruAnimatedStarIconWidget extends StatelessWidget {
  /// Create an animated Yaru star icon, similar to [YaruIcons.star].
  const YaruAnimatedStarIconWidget({
    super.key,
    this.size,
    this.filled,
    this.fillSize,
    this.color,
    required this.progress,
  });

  /// Determines the icon canvas size.
  /// To fit the original Yaru icon, the icon will be slightly smaller (20.0 on a 24.0 canvas).
  /// Defaults to 24.0 as the original Yaru icon.
  final double? size;

  /// Determines if the icon uses a solid background, like [YaruIcons.star_filled].
  /// Defaults to false.
  final bool? filled;

  /// Determines the filled part size, needs [filled] to be true.
  /// Ex: use 0.5 to looks like [YaruIcons.star_semi_filled].
  final double? fillSize;

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
    final filled = this.filled != null ? this.filled! : false;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _YaruAnimatedStarIconPainter(
            size,
            color,
            filled,
            fillSize ?? 1.0,
            progress.value,
          ),
        ),
      ),
    );
  }
}

class _YaruAnimatedStarIconPainter extends YaruSinglePathTracePainter {
  _YaruAnimatedStarIconPainter(
    super.size,
    super.color,
    super.filled,
    this.fillSize,
    super.progress,
  );

  final double fillSize;

  @override
  Path getPath() {
    return Path()
      ..moveTo(
        size * 0.5000000,
        size * 0.1243051,
      )
      ..lineTo(
        size * 0.4101923,
        size * 0.3922266,
      )
      ..lineTo(
        size * 0.1276126,
        size * 0.3948007,
      )
      ..lineTo(
        size * 0.3547775,
        size * 0.5629756,
      )
      ..lineTo(
        size * 0.2699035,
        size * 0.8325418,
      )
      ..lineTo(
        size * 0.5000000,
        size * 0.6685140,
      )
      ..lineTo(
        size * 0.7300965,
        size * 0.8325418,
      )
      ..lineTo(
        size * 0.6452225,
        size * 0.5629756,
      )
      ..lineTo(
        size * 0.8723874,
        size * 0.3948007,
      )
      ..lineTo(
        size * 0.5898077,
        size * 0.3922266,
      )
      ..close();
  }

  @override
  Path getFillPath() {
    final maskPath = Path()
      ..moveTo(size * fillSize, 0)
      ..lineTo(size, 0)
      ..lineTo(size, size)
      ..lineTo(size * fillSize, size)
      ..close();

    return Path.combine(
      PathOperation.difference,
      getPath(),
      maskPath,
    );
  }
}
