import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_togglable.dart';

const _kDotSizeFactor = 0.4;

class YaruRadio<T> extends YaruTogglable<T> {
  const YaruRadio({
    super.key,
    required super.value,
    required this.groupValue,
    this.toggleable = false,
    required super.onChanged,
    super.focusNode,
    super.autofocus,
  }) : assert(toggleable || value != null);

  final bool toggleable;

  @override
  bool get checked => value == groupValue;

  final T? groupValue;

  @override
  YaruTogglableState<YaruRadio<T>> createState() {
    return _YaruRadioState<T>();
  }
}

class _YaruRadioState<T> extends YaruTogglableState<YaruRadio<T>> {
  @override
  void handleTap([Intent? _]) {
    if (!interactive) {
      return;
    }

    if (widget.groupValue != widget.value || !widget.toggleable) {
      widget.onChanged!(widget.value);
    } else if (widget.toggleable) {
      widget.onChanged!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildToggleable(_YaruRadioPainter());
  }
}

class _YaruRadioPainter extends YaruTogglablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    final canvasSize = size;
    final t = position.value;
    final drawingOrigin = Offset(
      kCheckRadioActiveResizeFactor / 2 * sizePosition.value,
      kCheckRadioActiveResizeFactor / 2 * sizePosition.value,
    );
    final drawingSize = Size(
      canvasSize.width - kCheckRadioActiveResizeFactor * sizePosition.value,
      canvasSize.height - kCheckRadioActiveResizeFactor * sizePosition.value,
    );

    drawStateIndicator(canvas, canvasSize);
    _drawBox(canvas, drawingSize, drawingOrigin, t);
    _drawDot(canvas, drawingSize, drawingOrigin, t);
  }

  void _drawBox(Canvas canvas, Size size, Offset origin, double t) {
    canvas.drawOval(
      Rect.fromLTWH(
        origin.dx,
        origin.dy,
        size.width,
        size.height,
      ),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(uncheckedDisabledColor, checkedDisabledColor, t)!
        ..style = PaintingStyle.fill,
    );
  }

  void _drawDot(Canvas canvas, Size size, Offset origin, double t) {
    final center = (Offset.zero & size).center + origin;
    final dotSize = size * _kDotSizeFactor;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: dotSize.width * t,
        height: dotSize.height * t,
      ),
      Paint()
        ..color = interactive ? checkmarkColor : checkmarkDisabledColor
        ..style = PaintingStyle.fill,
    );
  }
}
