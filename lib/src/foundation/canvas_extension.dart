import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef CanvasCallback = void Function(Canvas canvas);

extension YaruCanvasExtension on Canvas {
  void paintScaled({
    required Offset origin,
    required Size scale,
    required CanvasCallback paint,
  }) {
    save();
    translate(origin.dx, origin.dy);
    this.scale(scale.width, scale.height);
    translate(-origin.dx, -origin.dy);
    paint(this);
    restore();
  }

  void paintRotated({
    required Offset center,
    required double angle,
    required CanvasCallback paint,
  }) {
    save();
    translate(center.dx, center.dy);
    rotate(math.pi * 2 * angle);
    translate(-center.dx, -center.dy);
    paint(this);
    restore();
  }
}
