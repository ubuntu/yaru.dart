import 'package:flutter/material.dart';

const yaruAnimatedOkIconAnimationCurve = Curves.easeInCubic;
const yaruAnimatedOkIconAnimationDuration = 500;
const _kTargetCanvasSize = 24.0;
const _kTargetIconSize = 20.0;

/// An animated Yaru ok icon, similar to the original one
class YaruAnimatedOkIcon extends StatefulWidget {
  /// Create an animated Yaru ok icon, similar to the original one
  const YaruAnimatedOkIcon({
    super.key,
    this.size = 24.0,
    this.filled = false,
    this.color,
    this.progress,
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

  /// The animation progress for the animated icon.
  /// The value is clamped to be between 0 and 1.
  /// If null, a defaut animation controller will be created, which will run only once.
  final Animation<double>? progress;

  @override
  State<YaruAnimatedOkIcon> createState() => _YaruAnimatedOkIconState();
}

class _YaruAnimatedOkIconState extends State<YaruAnimatedOkIcon>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;

  Animation<double> get progress => widget.progress ?? _animation;

  @override
  void initState() {
    super.initState();

    if (widget.progress == null) {
      _controller = AnimationController(
        duration:
            const Duration(milliseconds: yaruAnimatedOkIconAnimationDuration),
        vsync: this,
      );
      _animation = Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: yaruAnimatedOkIconAnimationCurve))
          .animate(_controller);

      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (widget.progress == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: SizedBox.square(
          dimension: widget.size,
          child: AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return CustomPaint(
                painter: _YaruAnimatedOkIconPainter(
                  widget.size,
                  widget.filled,
                  widget.color ?? Theme.of(context).colorScheme.onSurface,
                  progress.value,
                ),
              );
            },
          ),
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
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final bool filled;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (filled && progress >= 0.5) {
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
        ),
      );

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
        (size / 2 - 1) * _kTargetIconSize / _kTargetCanvasSize;
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
        (size / 2 - 1) * _kTargetIconSize / _kTargetCanvasSize;
    // From 1.0 to 0.75 to 1.0
    final circleRadius =
        progress < 0.5 ? 0.0 : (progress - 0.5) * 2 * finalCircleRadius;

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
    return oldDelegate.progress != progress ||
        oldDelegate.size != size ||
        oldDelegate.filled != filled ||
        oldDelegate.color != color;
  }
}
