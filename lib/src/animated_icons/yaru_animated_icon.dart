import 'package:flutter/material.dart';

/// Describes how a [YaruAnimatedIcon] will run.
enum YaruAnimationMode {
  /// Play the animation only one time.
  once,

  /// Play the animation indefinitely.
  repeat
}

/// A runner widget for all Yaru animated icons.
class YaruAnimatedIcon extends StatefulWidget {
  /// Create a Yaru animated icon runner.
  const YaruAnimatedIcon(
    this.data, {
    this.duration,
    this.curve,
    this.size,
    this.color,
    this.mode = YaruAnimationMode.once,
    super.key,
  });

  /// Describe which animation will be played.
  final YaruAnimatedIconData data;

  /// Duration of the animation.
  /// If null, defaults to [data.defaultDuration].
  final Duration? duration;

  /// Curve used to play the animation.
  /// If null, defaults to [data.defaultCurve].
  final Curve? curve;

  /// Size of the canvas used to draw the icon.
  /// If null, the default value of the related [data.build] widget will be used.
  final double? size;

  /// Color used to draw the icon.
  /// If null, the default value of the related [data.build] widget will be used.
  final Color? color;

  /// Describes how the animation will run.
  /// See [YaruAnimationMode].
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

/// Interface class for a Yaru animated icon.
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
