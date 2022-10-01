import 'package:flutter/material.dart';

const _kTargetCanvasSize = 24.0;
const _kTargetIconSize = 20.0;
const _kAnimationCurve = Curves.easeInCubic;
const _kAnimationDuration = 500;

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
  State<YaruAnimatedOkIcon> createState() => _YaruAnimatedOkIconState();
}

class _YaruAnimatedOkIconState extends State<YaruAnimatedOkIcon>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;

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
      final clipRect = Rect.fromCenter(
        center: Offset.zero,
        width: this.size * 2,
        height: this.size * 2,
      );
      final clipPath = Path.combine(
          PathOperation.difference,
          Path()..addRect(clipRect),
          Path.combine(
            PathOperation.intersect,
            _createCheckmarkPath(true),
            _createInnerCirclePath(true),
          ));

      canvas.save();
      canvas.clipPath(clipPath);
      canvas.saveLayer(clipRect, Paint());

      canvas.drawPath(_createOuterCirclePath(), _createStrokePaint());
      canvas.drawPath(_createInnerCirclePath(false), _createFillPaint());
      canvas.drawPath(_createCheckmarkPath(false), _createFillPaint());

      canvas.restore();
      canvas.restore();
    } else {
      canvas.drawPath(_createCheckmarkPath(false), _createFillPaint());
      canvas.drawPath(_createOuterCirclePath(), _createStrokePaint());
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

    if (animationPosition < 0.5) {
      final pathT = animationPosition * 2.0;
      final drawMid1 = Offset.lerp(start1, mid1, pathT)!;
      final drawMid2 = Offset.lerp(start2, mid2, pathT)!;

      checkmark.moveTo(start1.dx, start1.dy);
      checkmark.lineTo(drawMid1.dx, drawMid1.dy);
      checkmark.lineTo(drawMid2.dx, drawMid2.dy);
      checkmark.lineTo(start2.dx, start2.dy);
      checkmark.close();
    } else {
      final pathT = (animationPosition - 0.5) * 2.0;
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

  /// [large] param is used to increase circle radius from half pain stroke for canvas clip
  Path _createInnerCirclePath(bool large) {
    final finalCircleRadius =
        (size / 2 - 1) * _kTargetIconSize / _kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius = animationPosition < 0.5
        ? 0.0
        : (animationPosition - 0.5) * 2 * finalCircleRadius;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size / 2, size / 2),
          radius: large
              ? circleRadius + (1 / (_kTargetCanvasSize / size) / 2)
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
      ..strokeWidth = 1 / (_kTargetCanvasSize / size)
      ..blendMode = BlendMode.src;
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
