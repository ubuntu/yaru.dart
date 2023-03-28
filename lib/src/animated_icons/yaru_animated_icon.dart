import 'package:flutter/material.dart';

enum YaruAnimationMode { once, repeat }

class YaruAnimatedIcon extends StatefulWidget {
  const YaruAnimatedIcon(
    this.data, {
    this.duration,
    this.curve,
    this.size,
    this.color,
    this.mode = YaruAnimationMode.once,
    super.key,
  });

  final YaruAnimatedIconData data;
  final Duration? duration;
  final Curve? curve;
  final double? size;
  final Color? color;
  final YaruAnimationMode mode;

  @override
  State<YaruAnimatedIcon> createState() => _YaruAnimatedIconState();
}

class _YaruAnimatedIconState extends State<YaruAnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  void _initAnimationController(Duration? duration, YaruAnimationMode mode) {
    _controller?.stop();
    _controller?.value = 0;
    _controller = AnimationController(
      vsync: this,
      duration: duration ?? widget.data.defaultDuration,
    );

    switch (mode) {
      case YaruAnimationMode.once:
        _controller!.forward();
        break;
      case YaruAnimationMode.repeat:
        _controller!.repeat();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _initAnimationController(widget.duration, widget.mode);
  }

  @override
  void didUpdateWidget(covariant YaruAnimatedIcon old) {
    if (widget.mode != old.mode) {
      _initAnimationController(widget.duration, widget.mode);
    }

    if (widget.duration != old.duration) {
      _initAnimationController(widget.duration, widget.mode);
    }

    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const SizedBox();

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        return widget.data.build(
          context,
          CurvedAnimation(
            parent: _controller!,
            curve: widget.curve ?? widget.data.defaultCurve,
          ),
          widget.size,
          widget.color,
        );
      },
    );
  }
}

abstract class YaruAnimatedIconData {
  const YaruAnimatedIconData();

  Duration get defaultDuration;
  Curve get defaultCurve => Curves.linear;

  Widget build(
    BuildContext context,
    Animation<double> progress,
    double? size,
    Color? color,
  );
}
