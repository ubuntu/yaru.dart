import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_togglable.dart';

const _kCheckboxBorderRadius = Radius.circular(4);
const _kCheckboxDashStroke = 2.0;
const _kDashSizeFactor = 0.52;

class YaruCheckbox extends YaruTogglable<bool?> {
  const YaruCheckbox({
    super.key,
    required super.value,
    super.tristate,
    super.onChanged,
    super.focusNode,
    super.autofocus,
  }) : assert(tristate || value != null);

  @override
  bool? get checked => value;

  @override
  YaruTogglableState<YaruCheckbox> createState() {
    return _YaruCheckboxState();
  }
}

class _YaruCheckboxState extends YaruTogglableState<YaruCheckbox> {
  @override
  bool get interactive => widget.onChanged != null;

  @override
  void handleTap([Intent? _]) {
    if (!interactive) {
      return;
    }
    switch (widget.value) {
      case false:
        widget.onChanged!(true);
        break;
      case true:
        widget.onChanged!(widget.tristate ? null : false);
        break;
      case null:
        widget.onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildToggleable(_YaruCheckboxPainter());
  }
}

class _YaruCheckboxPainter extends YaruTogglablePainter {
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
    _drawBox(
      canvas,
      drawingSize,
      drawingOrigin,
      oldChecked == false || checked == false ? t : 1,
    );

    // Four cases: false to null, false to true, null to false, true to false
    if (oldChecked == false || checked == false) {
      if (oldChecked == true || checked == true) {
        _drawCheckMark(canvas, drawingSize, drawingOrigin, t);
      } else if (oldChecked == null || checked == null) {
        _drawDash(canvas, drawingSize, drawingOrigin, t);
      }
    }
    // Two cases: null to true, true to null
    else {
      if (t <= 0.5) {
        final tShrink = 1 - t * 2;
        if (oldChecked == true) {
          _drawCheckMark(canvas, drawingSize, drawingOrigin, tShrink);
        } else {
          _drawDash(canvas, drawingSize, drawingOrigin, tShrink);
        }
      } else {
        final tExpand = (t - 0.5) * 2.0;
        if (checked == true) {
          _drawCheckMark(canvas, drawingSize, drawingOrigin, tExpand);
        } else {
          _drawDash(canvas, drawingSize, drawingOrigin, tExpand);
        }
      }
    }
  }

  void _drawBox(Canvas canvas, Size size, Offset origin, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height),
        _kCheckboxBorderRadius,
      ),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(uncheckedDisabledColor, checkedDisabledColor, t)!
        ..style = PaintingStyle.fill,
    );
  }

  void _drawCheckMark(Canvas canvas, Size size, Offset origin, double t) {
    final path = Path();

    final start = Offset(size.width * 0.1818, size.height * 0.4545);
    final mid = Offset(size.width * 0.4091, size.height * 0.6818);
    final end = Offset(size.width * 0.8128, size.height * 0.2781);

    if (t < 0.5) {
      final strokeT = t * 2.0;
      final drawMid = Offset.lerp(start, mid, strokeT)!;

      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
      path.lineTo(origin.dx + start.dx, origin.dy + start.dy);
    } else {
      final strokeT = (t - 0.5) * 2.0;
      final drawEnd = Offset.lerp(mid, end, strokeT)!;

      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }

    canvas.drawPath(
      path,
      _getCheckmarkPaint(),
    );
  }

  void _drawDash(Canvas canvas, Size size, Offset origin, double t) {
    const dashMarginFactor = (1 - _kDashSizeFactor) / 2;

    final start = Offset(size.width * dashMarginFactor, size.height * 0.5);
    final mid = Offset(size.width * 0.5, size.height * 0.5);
    final end = Offset(size.width * (1 - dashMarginFactor), size.height * 0.5);

    final drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final drawEnd = Offset.lerp(mid, end, t)!;

    canvas.drawLine(
      origin + drawStart,
      origin + drawEnd,
      _getCheckmarkPaint(),
    );
  }

  Paint _getCheckmarkPaint() {
    return Paint()
      ..color = interactive ? checkmarkColor : checkmarkDisabledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kCheckboxDashStroke;
  }
}
