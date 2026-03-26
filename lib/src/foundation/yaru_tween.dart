import 'package:flutter/material.dart';

class ProgressiveVisibilityTween extends Animatable<double> {
  ProgressiveVisibilityTween({
    required this.fadeOutStart,
    required this.fadeOutEnd,
    required this.fadeInStart,
    required this.fadeInEnd,
  });

  final double fadeOutStart;
  final double fadeOutEnd;
  final double fadeInStart;
  final double fadeInEnd;

  @override
  double transform(double t) {
    assert(fadeOutStart < fadeOutEnd);
    assert(fadeInStart < fadeInEnd);
    assert(fadeOutEnd <= fadeInStart);

    if (t < fadeOutStart) {
      return 1.0;
    } else if (t < fadeOutEnd) {
      return 1.0 - ((t - fadeOutStart) / (fadeOutEnd - fadeOutStart));
    } else if (t < fadeInStart) {
      return 0.0;
    } else if (t < fadeInEnd) {
      return (t - fadeInStart) / (fadeInEnd - fadeInStart);
    } else {
      return 1.0;
    }
  }
}

class YaruClampingTween extends Animatable<double> {
  YaruClampingTween(this.start, this.end);

  final double start;
  final double end;

  @override
  double transform(double t) {
    if (t <= start) {
      return 0.0;
    } else if (t >= end) {
      return 1.0;
    } else {
      return (t - start) / (end - start);
    }
  }
}
