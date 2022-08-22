import 'package:flutter/material.dart';

class YaruAnimatedOkIcon extends StatefulWidget {
  const YaruAnimatedOkIcon({this.size = 60.0, super.key});

  final double size;

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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // TODO: _controller.forward();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: ((context, child) {
            return CustomPaint(
              painter: _YaruAnimatedOkIconPainter(
                widget.size,
                _animation.value,
              ),
            );
          }),
        ),
      ),
    );
  }
}

// From path circle to filled
// From 1.0x to 0.95x to 1.0x
// Draw checkmark during the whole animation

class _YaruAnimatedOkIconPainter extends CustomPainter {
  _YaruAnimatedOkIconPainter(this.size, this.animationPosition);

  final double size;
  final double animationPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final checkMark = Path()
      ..moveTo(size.width / 3, size.width / 2)
      ..lineTo(size.width * 0.521, size.width * 0.688)
      ..lineTo(size.width, size.width * 0.208);

    final circle = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 - 1,
        ),
      );

    canvas.drawPath(
      checkMark,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(
    _YaruAnimatedOkIconPainter oldDelegate,
  ) {
    return oldDelegate.animationPosition != animationPosition ||
        oldDelegate.size != size;
  }
}
