import 'package:flutter/material.dart';

import 'yaru_togglable.dart';

const _kSwitchActivableAreaPadding =
    EdgeInsets.symmetric(horizontal: 4, vertical: 5);
const _kSwitchSize = Size(55, 30);
const _kSwitchDotSizeFactor = 0.8;

class YaruSwitch extends YaruTogglable<bool> {
  const YaruSwitch({
    super.key,
    required super.value,
    required super.onChanged,
    super.focusNode,
    super.autofocus,
  });

  @override
  bool get checked => value;

  @override
  bool get tristate => false;

  @override
  YaruTogglableState<YaruSwitch> createState() {
    return _YaruSwitchState();
  }
}

class _YaruSwitchState extends YaruTogglableState<YaruSwitch> {
  @override
  EdgeInsets get activableAreaPadding => _kSwitchActivableAreaPadding;

  @override
  Size get togglableSize => _kSwitchSize;

  @override
  void handleTap([Intent? _]) {
    if (!widget.interactive) {
      return;
    }

    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return buildToggleable(_YaruSwitchPainter());
  }
}

class _YaruSwitchPainter extends YaruTogglablePainter {
  @override
  void paintTogglable(
    Canvas canvas,
    Size realSize,
    Size size,
    Offset origin,
    double t,
  ) {
    _drawBox(canvas, size, origin, t);
    _drawDot(canvas, size, origin, t);
  }

  void _drawBox(Canvas canvas, Size size, Offset origin, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height),
        Radius.circular(size.height),
      ),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(uncheckedDisabledColor, checkedDisabledColor, t)!
        ..style = PaintingStyle.fill,
    );
  }

  void _drawDot(Canvas canvas, Size size, Offset origin, double t) {
    final margin = (size.height - size.height * _kSwitchDotSizeFactor) / 2;
    final innerSize = Size(
      size.width - margin * 2,
      size.height - margin * 2,
    );
    final radius = innerSize.height / 2;

    final start = Offset(radius + margin, radius + margin);
    final end = Offset(innerSize.width + margin - radius, radius + margin);
    final center = Offset.lerp(start, end, t)! + origin;

    final paint = Paint()
      ..color = interactive ? checkmarkColor : checkmarkDisabledColor
      ..style = PaintingStyle.fill;

    drawStateIndicator(canvas, size, center);
    canvas.drawCircle(center, radius, paint);
  }
}
