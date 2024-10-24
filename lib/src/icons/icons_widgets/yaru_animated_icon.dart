import 'package:animated_vector/animated_vector.dart';
import 'package:flutter/material.dart';

/// Describes how a [YaruAnimatedIcon] will run.
enum YaruAnimationMode {
  /// Play the animation only one time.
  once,

  /// Play the animation indefinitely.
  repeat
}

/// A runner widget for all Yaru animated icons.
class YaruAnimatedVectorIcon extends StatefulWidget {
  /// Create a Yaru animated icon runner.
  const YaruAnimatedVectorIcon(
    this.data, {
    this.duration,
    this.size,
    this.color,
    this.mode = YaruAnimationMode.once,
    this.initialProgress,
    super.key,
  });

  /// Describe which animation will be played.
  final AnimatedVectorData data;

  /// Duration of the animation.
  /// If null, defaults to [data.duration].
  final Duration? duration;

  /// Size of the canvas used to draw the icon.
  /// If null, the default value of the related [data.build] widget will be used.
  final double? size;

  /// Color used to draw the icon.
  /// If null, the default value of the related [data.build] widget will be used.
  final Color? color;

  /// Describes how the animation will run.
  /// See [YaruAnimationMode].
  final YaruAnimationMode mode;

  /// Initial progress of the animation.
  /// If null, the animation will play from the beginning.
  final double? initialProgress;

  @override
  State<YaruAnimatedVectorIcon> createState() => _YaruAnimatedVectorIconState();
}

class _YaruAnimatedVectorIconState extends State<YaruAnimatedVectorIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.initialProgress,
      vsync: this,
      duration: widget.data.duration,
    );
    _runAnimationController();
  }

  @override
  void didUpdateWidget(YaruAnimatedVectorIcon old) {
    if (widget.data != old.data) {
      _controller.value = 0.0;
    }
    if (widget.duration != old.duration) {
      _controller.duration = widget.duration ?? widget.data.duration;
    }
    if (widget.mode != old.mode || widget.data != old.data) {
      _runAnimationController();
    }

    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimationController() {
    switch (widget.mode) {
      case YaruAnimationMode.once:
        _controller.forward();
        break;
      case YaruAnimationMode.repeat:
        _controller.repeat();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AnimatedVector(
          vector: widget.data,
          progress: _controller,
          size: widget.size != null ? Size.square(widget.size!) : null,
          applyTheme: true,
          color: widget.color,
        );
      },
    );
  }
}
