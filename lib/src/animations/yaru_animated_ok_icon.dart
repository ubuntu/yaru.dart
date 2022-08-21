import 'package:flutter/material.dart';

class YaruAnimatedOkIcon extends StatefulWidget {
  const YaruAnimatedOkIcon({super.key});

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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // TODO: _controller.forward();
    _controller.repeat();
  }

  @override
  void dispose() {
    // Properly dispose the controller. This is important!
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: ((context, child) {
        return CustomPaint(
          painter: _YaruAnimatedOkIconPainter(_animation.value),
        );
      }),
    );
  }
}

// From path circle to filled
// From 1.0x to 0.95x to 1.0x
// Draw checkmark during the whole animation

class _YaruAnimatedOkIconPainter extends CustomPainter {
  _YaruAnimatedOkIconPainter(this.animationPosition);

  double animationPosition;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      40.0 + 10.0 * animationPosition,
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(
    _YaruAnimatedOkIconPainter oldDelegate,
  ) {
    return oldDelegate.animationPosition != animationPosition;
  }
}
