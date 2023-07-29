import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../foundation/canvas_extension.dart';
import '../../foundation/local_progress_mixin.dart';

abstract class YaruSinglePathTracePainter extends CustomPainter
    with LocalProgress {
  const YaruSinglePathTracePainter(
    this.size,
    this.color,
    this.filled,
    this.progress,
  ) : assert(progress >= 0.0 && progress <= 1.0);

  final double size;
  final Color color;
  final bool filled;
  @override
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < .5) {
      final metric = getPath().computeMetrics().single;
      final localProgress = computeLocalProgress(0, .5);
      final drawPath = metric.extractPath(
        metric.length / 2 - metric.length / 2 * localProgress,
        metric.length / 2 + metric.length / 2 * localProgress,
      );

      canvas.drawPath(
        drawPath,
        _getStrokePaint(),
      );
    } else {
      final center = Offset(this.size / 2, this.size / 2);
      final localProgress = computeLocalProgress(.5, .5);
      final scale = localProgress < .5
          ? 1 - .25 * computeLocalProgress(.5, .25)
          : .75 + .25 * computeLocalProgress(.75, .25);

      canvas.paintScaled(
        origin: center,
        scale: Size.square(scale),
        paint: (canvas) {
          canvas.drawPath(
            getPath(),
            _getStrokePaint(),
          );
        },
      );

      if (filled && localProgress >= .5) {
        canvas.paintScaled(
          origin: center,
          scale: Size.square(computeLocalProgress(.75, .25)),
          paint: (canvas) {
            canvas.drawPath(
              getFillPath() ?? getPath(),
              _getFillPaint(),
            );
          },
        );
      }
    }
  }

  Path getPath();

  Path? getFillPath() => null;

  Paint _getFillPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..blendMode = BlendMode.src;
  }

  Paint _getStrokePaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1 / (kTargetCanvasSize / size)
      ..blendMode = BlendMode.src;
  }

  @override
  bool shouldRepaint(YaruSinglePathTracePainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.color != color ||
        oldDelegate.filled != filled ||
        oldDelegate.progress != progress;
  }
}
