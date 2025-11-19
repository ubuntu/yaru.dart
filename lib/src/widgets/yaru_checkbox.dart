import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_togglable.dart';

// NOTE: keep in sync with Radio
const _kCheckboxActivableAreaPadding = EdgeInsets.all(6);
const _kCheckboxTogglableSize = Size.square(20);

const _kCheckboxBorderRadius = Radius.circular(kYaruCheckRadius);
const _kCheckboxDashStroke = 2.0;
const _kDashSizeFactor = 0.52;

/// A Yaru checkbox.
///
/// The checkbox itself does not maintain any state. Instead, when the state of
/// the checkbox changes, the widget calls the [onChanged] callback. Most
/// widgets that use a checkbox will listen for the [onChanged] callback and
/// rebuild the checkbox with a new [value] to update the visual appearance of
/// the checkbox.
///
/// The checkbox can optionally display three values - true, false, and null -
/// if [tristate] is true. When [value] is null a dash is displayed. By default
/// [tristate] is false and the checkbox's [value] must be true or false.
///
/// See also:
///
///  * [YaruCheckButton], a desktop style check button with an interactive label.
///  * [YaruSwitch], a widget with semantics similar to [Checkbox].
///  * [YaruRadio], for selecting among a set of explicit values.
///  * [Slider], for selecting a value in a range.
class YaruCheckbox extends StatefulWidget implements YaruTogglable<bool?> {
  /// A Yaru checkbox.
  ///
  /// The checkbox itself does not maintain any state. Instead, when the state of
  /// the checkbox changes, the widget calls the [onChanged] callback. Most
  /// widgets that use a checkbox will listen for the [onChanged] callback and
  /// rebuild the checkbox with a new [value] to update the visual appearance of
  /// the checkbox.
  const YaruCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.selectedColor,
    this.checkmarkColor,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.statesController,
    this.hasFocusBorder,
  }) : assert(tristate || value != null);

  /// Whether this checkbox is checked.
  ///
  /// This property must not be null.
  @override
  final bool? value;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  @override
  final bool tristate;

  @override
  bool? get checked => value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// value.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// When the checkbox is tapped, if [tristate] is false (the default) then
  /// the [onChanged] callback will be applied to `!value`. If [tristate] is
  /// true this callback cycle from false to true to null.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// YaruCheckbox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  @override
  final ValueChanged<bool?>? onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ColorScheme.primary].
  final Color? selectedColor;

  /// The color to use for the checkmark when this checkbox is checked.
  ///
  /// Defaults to [ColorScheme.onPrimary].
  final Color? checkmarkColor;

  @override
  bool get interactive => onChanged != null;

  /// {@macro flutter.widgets.Focus.focusNode}
  @override
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  @override
  final bool autofocus;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  final MouseCursor? mouseCursor;

  @override
  final WidgetStatesController? statesController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool?>(
        'value',
        checked,
        description: checked == null
            ? 'mixed'
            : checked == true
            ? 'checked'
            : 'unchecked',
        showName: false,
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<bool?>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
  }

  @override
  YaruTogglableState<YaruCheckbox> createState() {
    return _YaruCheckboxState();
  }
}

class _YaruCheckboxState extends YaruTogglableState<YaruCheckbox> {
  @override
  EdgeInsetsGeometry get activableAreaPadding => _kCheckboxActivableAreaPadding;

  @override
  Size get togglableSize => _kCheckboxTogglableSize;

  @override
  void handleTap([Intent? _]) {
    if (!widget.interactive) {
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
    final checkboxTheme = YaruCheckboxTheme.of(context);
    final painter = _YaruCheckboxPainter();
    fillPainterDefaults(painter);

    const unselectedState = <WidgetState>{};
    const selectedState = {WidgetState.selected};
    const disabledState = {WidgetState.disabled};
    const selectedDisabledState = {WidgetState.selected, WidgetState.disabled};

    // Normal colors
    final uncheckedColor =
        checkboxTheme.color?.resolve(unselectedState) ?? painter.uncheckedColor;
    final uncheckedBorderColor =
        checkboxTheme.borderColor?.resolve(unselectedState) ??
        painter.uncheckedBorderColor;
    final checkedColor =
        widget.selectedColor ??
        checkboxTheme.color?.resolve(selectedState) ??
        painter.checkedColor;
    final checkedBorderColor =
        checkboxTheme.borderColor?.resolve(selectedState) ??
        painter.checkedBorderColor;
    final checkmarkColor =
        widget.checkmarkColor ??
        checkboxTheme.checkmarkColor?.resolve(selectedState) ??
        painter.checkmarkColor;

    // Disabled colors
    final disabledUncheckedColor =
        checkboxTheme.color?.resolve(disabledState) ??
        painter.disabledUncheckedColor;
    final disabledUncheckedBorderColor =
        checkboxTheme.borderColor?.resolve(disabledState) ??
        painter.disabledUncheckedBorderColor;
    final disabledCheckedColor =
        checkboxTheme.color?.resolve(selectedDisabledState) ??
        painter.disabledCheckedColor;
    final disabledCheckedBorderColor =
        checkboxTheme.borderColor?.resolve(selectedDisabledState) ??
        painter.disabledCheckedBorderColor;
    final disabledCheckmarkColor =
        checkboxTheme.checkmarkColor?.resolve(selectedDisabledState) ??
        painter.disabledCheckmarkColor;

    // Indicator colors
    final hoverIndicatorColor =
        checkboxTheme.indicatorColor?.resolve({WidgetState.hovered}) ??
        painter.hoverIndicatorColor;
    final focusIndicatorColor =
        checkboxTheme.indicatorColor?.resolve({WidgetState.focused}) ??
        painter.focusIndicatorColor;

    final checkboxWidget = buildToggleable(
      painter
        ..uncheckedColor = uncheckedColor
        ..uncheckedBorderColor = uncheckedBorderColor
        ..checkedColor = checkedColor
        ..checkedBorderColor = checkedBorderColor
        ..checkmarkColor = checkmarkColor
        ..disabledUncheckedColor = disabledUncheckedColor
        ..disabledUncheckedBorderColor = disabledUncheckedBorderColor
        ..disabledCheckedColor = disabledCheckedColor
        ..disabledCheckedBorderColor = disabledCheckedBorderColor
        ..disabledCheckmarkColor = disabledCheckmarkColor
        ..hoverIndicatorColor = hoverIndicatorColor
        ..focusIndicatorColor = focusIndicatorColor,
      mouseCursor:
          widget.mouseCursor ??
          checkboxTheme.mouseCursor?.resolve({
            if (!widget.interactive) WidgetState.disabled,
          }),
    );

    return widget.hasFocusBorder ??
            YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(child: checkboxWidget)
        : checkboxWidget;
  }
}

class _YaruCheckboxPainter extends YaruTogglablePainter {
  @override
  void paintTogglable(Canvas canvas, Size size, double t) {
    drawStateIndicator(canvas, size);
    _drawBox(canvas, size, oldChecked == false || checked == false ? t : 1);

    // Four cases: false to null, false to true, null to false, true to false
    if (oldChecked == false || checked == false) {
      if (oldChecked == true || checked == true) {
        _drawCheckMark(canvas, size, t);
      } else if (oldChecked == null || checked == null) {
        _drawDash(canvas, size, t);
      }
    }
    // Two cases: null to true, true to null
    else {
      if (t <= 0.5) {
        final tShrink = 1 - t * 2;
        if (oldChecked == true) {
          _drawCheckMark(canvas, size, tShrink);
        } else {
          _drawDash(canvas, size, tShrink);
        }
      } else {
        final tExpand = (t - 0.5) * 2.0;
        if (checked == true) {
          _drawCheckMark(canvas, size, tExpand);
        } else {
          _drawDash(canvas, size, tExpand);
        }
      }
    }
  }

  void _drawBox(Canvas canvas, Size size, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, _kCheckboxBorderRadius),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(disabledUncheckedColor, disabledCheckedColor, t)!
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.5, 0.5, size.width - 1.0, size.height - 1.0),
        _kCheckboxBorderRadius,
      ),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedBorderColor, checkedBorderColor, t)!
            : Color.lerp(
                disabledUncheckedBorderColor,
                disabledCheckedBorderColor,
                t,
              )!
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawCheckMark(Canvas canvas, Size size, double t) {
    final path = Path();

    final start = Offset(size.width * 0.1818, size.height * 0.4545);
    final mid = Offset(size.width * 0.4091, size.height * 0.6818);
    final end = Offset(size.width * 0.8128, size.height * 0.2781);

    if (t < 0.5) {
      final strokeT = t * 2.0;
      final drawMid = Offset.lerp(start, mid, strokeT)!;

      path.moveTo(start.dx, start.dy);
      path.lineTo(drawMid.dx, drawMid.dy);
      path.lineTo(start.dx, start.dy);
    } else {
      final strokeT = (t - 0.5) * 2.0;
      final drawEnd = Offset.lerp(mid, end, strokeT)!;

      path.moveTo(start.dx, start.dy);
      path.lineTo(mid.dx, mid.dy);
      path.lineTo(drawEnd.dx, drawEnd.dy);
    }

    canvas.drawPath(path, _getCheckmarkPaint());
  }

  void _drawDash(Canvas canvas, Size size, double t) {
    const dashMarginFactor = (1 - _kDashSizeFactor) / 2;

    final start = Offset(size.width * dashMarginFactor, size.height * 0.5);
    final mid = Offset(size.width * 0.5, size.height * 0.5);
    final end = Offset(size.width * (1 - dashMarginFactor), size.height * 0.5);

    final drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final drawEnd = Offset.lerp(mid, end, t)!;

    canvas.drawLine(drawStart, drawEnd, _getCheckmarkPaint());
  }

  Paint _getCheckmarkPaint() {
    return Paint()
      ..color = interactive ? checkmarkColor : disabledCheckmarkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kCheckboxDashStroke;
  }
}
