import 'package:flutter/material.dart';

const _kTargetCanvasSize = 24.0;
const _kTargetIconSize = 20.0;
const _kAnimationCurve = Curves.easeInCubic;
const _kAnimationDuration = 400;

/// An animated Yaru ok icon, similar to the original one
class YaruAnimatedOkIcon extends StatefulWidget {
  /// Create an animated Yaru ok icon, similar to the original one
  const YaruAnimatedOkIcon({
    this.size = 24.0,
    this.filled = false,
    this.color,
    this.onCompleted,
    super.key,
  });

  /// Determines the icon canvas size
  /// To fit the original Yaru icon, the icon will be slightly smaller (20.0 on a 24.0 canvas)
  /// Defaults to 24.0  as the original Yaru icon
  final double size;

  /// Determines if the icon uses a solid background
  /// Defaults to false as the original Yaru icon
  final bool filled;

  /// Color used to draw the icon
  /// If null, defaults to colorScheme.onSurface
  final Color? color;

  /// Callback called once animation completed
  final Function? onCompleted;

  @override
  _YaruAnimatedOkIconState createState() => _YaruAnimatedOkIconState();
}

class _YaruAnimatedOkIconState extends State<YaruAnimatedOkIcon>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: _kAnimationDuration),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: _kAnimationCurve))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: ((context, child) {
            return CustomPaint(
              painter: _YaruAnimatedOkIconPainter(
                widget.size,
                widget.filled,
                widget.color ?? Theme.of(context).colorScheme.onSurface,
                _animation.value,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _YaruAnimatedOkIconPainter extends CustomPainter {
  _YaruAnimatedOkIconPainter(
    this.size,
    this.filled,
    this.color,
    this.animationPosition,
  ) : assert(animationPosition >= 0.0 && animationPosition <= 1.0);

  final double size;
  final bool filled;
  final Color color;
  final double animationPosition;

  @override
  void paint(Canvas canvas, Size size) {
    if (filled && animationPosition >= 0.5) {
      canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          _createCirclePath(),
          _createCheckmarkPath(),
        ),
        _createFillPaint(),
      );
    } else {
      canvas.drawPath(_createCheckmarkPath(), _createFillPaint());
      canvas.drawPath(_createCirclePath(), _createStrokePaint());
    }
  }

  Path _createCheckmarkPath() {
    final Path checkmark = Path();
    final Offset start1 = Offset(size * 0.354, size * 0.477);
    final Offset start2 = Offset(size * 0.310, size * 0.521);
    final Offset mid1 = Offset(size * 0.521, size * 0.643);
    final Offset mid2 = Offset(size * 0.521, size * 0.732);
    final Offset end1 = Offset(size * 0.865, size * 0.299);
    final Offset end2 = Offset(size * 0.892, size * 0.360);

    if (animationPosition < 0.5) {
      final double pathT = animationPosition * 2.0;
      final Offset drawMid1 = Offset.lerp(start1, mid1, pathT)!;
      final Offset drawMid2 = Offset.lerp(start2, mid2, pathT)!;

      checkmark.moveTo(start1.dx, start1.dy);
      checkmark.lineTo(drawMid1.dx, drawMid1.dy);
      checkmark.lineTo(drawMid2.dx, drawMid2.dy);
      checkmark.lineTo(start2.dx, start2.dy);
      checkmark.close();
    } else {
      final double pathT = (animationPosition - 0.5) * 2.0;
      final Offset drawEnd1 = Offset.lerp(mid1, end1, pathT)!;
      final Offset drawEnd2 = Offset.lerp(mid2, end2, pathT)!;

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

  Path _createCirclePath() {
    final finalCircleRadius =
        (size / 2 - 1) * _kTargetIconSize / _kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius = animationPosition < 0.5
        ? finalCircleRadius - finalCircleRadius * 0.25 * animationPosition
        : finalCircleRadius * 0.75 +
            finalCircleRadius * 0.25 * animationPosition;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size / 2, size / 2),
          radius: circleRadius,
        ),
      );
  }

  Paint _createFillPaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  Paint _createStrokePaint() {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / (_kTargetCanvasSize / size);
  }

  @override
  bool shouldRepaint(
    _YaruAnimatedOkIconPainter oldDelegate,
  ) {
    return oldDelegate.animationPosition != animationPosition ||
        oldDelegate.size != size ||
        oldDelegate.filled != filled ||
        oldDelegate.color != color;
  }
}
