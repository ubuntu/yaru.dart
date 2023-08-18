import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_checkbox.dart';
import 'yaru_radio.dart';
import 'yaru_switch_button.dart';
import 'yaru_switch_theme.dart';
import 'yaru_togglable.dart';

const _kSwitchActivableAreaPadding =
    EdgeInsets.symmetric(horizontal: 2, vertical: 5);
const _kSwitchSize = Size(55, 30);
const _kSwitchThumbSizeFactor = 0.8;

/// A Yaru switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// If the [onChanged] callback is null, then the switch will be disabled (it
/// will not respond to input). A disabled switch's thumb and track are rendered
/// in shades of grey by default. The default appearance of a disabled switch
/// can be overridden with [inactiveThumbColor] and [inactiveTrackColor].
///
/// See also:
///
///  * [YaruSwitchButton], a desktop style switch button with an interactive label.
///  * [YaruCheckbox], another widget with similar semantics.
///  * [YaruRadio], for selecting among a set of explicit values.
///  * [Slider], for selecting a value in a range.
class YaruSwitch extends StatefulWidget implements YaruTogglable<bool> {
  const YaruSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.selectedColor,
    this.thumbColor,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.statesController,
  });

  /// Whether this switch is on or off.
  ///
  /// This property must not be null.
  @override
  final bool value;

  @override
  bool get checked => value;

  @override
  bool get tristate => false;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// YaruSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  @override
  final ValueChanged<bool>? onChanged;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [ColorScheme.primary].
  final Color? selectedColor;

  /// The color to use for the thumb when this switch is on.
  ///
  /// Defaults to [ColorScheme.onPrimary].
  final Color? thumbColor;

  @override
  bool get interactive => onChanged != null;

  /// {@macro flutter.widgets.Focus.focusNode}
  @override
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  @override
  final bool autofocus;

  @override
  final MouseCursor? mouseCursor;

  @override
  final MaterialStatesController? statesController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'value',
        value: checked,
        ifTrue: 'on',
        ifFalse: 'off',
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
  }

  @override
  YaruTogglableState<YaruSwitch> createState() {
    return _YaruSwitchState();
  }
}

class _YaruSwitchState extends YaruTogglableState<YaruSwitch> {
  @override
  EdgeInsetsGeometry get activableAreaPadding => _kSwitchActivableAreaPadding;

  @override
  Size get togglableSize => _kSwitchSize;

  bool isDragging = false;

  @override
  void handleTap([Intent? _]) {
    if (!widget.interactive) {
      return;
    }

    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final switchTheme = YaruSwitchTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final painter = _YaruSwitchPainter();
    fillPainterDefaults(painter);

    const unselectedState = <MaterialState>{};
    const selectedState = {MaterialState.selected};
    const disabledState = {MaterialState.disabled};
    const selectedDisabledState = {
      MaterialState.selected,
      MaterialState.disabled,
    };

    final defaultBorderColor = colorScheme.isHighContrast
        ? colorScheme.outlineVariant
        : Colors.transparent;

    // Normal colors
    final uncheckedColor = switchTheme.color?.resolve(unselectedState) ??
        colorScheme.onSurface.withOpacity(.25);
    final uncheckedBorderColor =
        switchTheme.borderColor?.resolve(unselectedState) ?? defaultBorderColor;
    final uncheckedThumbColor =
        switchTheme.thumbColor?.resolve(unselectedState) ?? Colors.white;
    final checkedColor = widget.selectedColor ??
        switchTheme.color?.resolve(selectedState) ??
        painter.checkedColor;
    final checkedBorderColor =
        switchTheme.borderColor?.resolve(selectedState) ?? defaultBorderColor;
    final checkedThumbColor = widget.thumbColor ??
        switchTheme.thumbColor?.resolve(selectedState) ??
        painter.checkmarkColor;

    // Disabled colors
    final disabledUncheckedColor = switchTheme.color?.resolve(disabledState) ??
        painter.disabledUncheckedColor;
    final disabledUncheckedBorderColor =
        switchTheme.borderColor?.resolve(disabledState) ?? defaultBorderColor;
    final disabledUncheckedThumbColor =
        switchTheme.thumbColor?.resolve(disabledState) ??
            colorScheme.onSurface.withOpacity(.4);
    final disabledCheckedColor =
        switchTheme.color?.resolve(selectedDisabledState) ??
            painter.disabledCheckedColor;
    final disabledCheckedBorderColor =
        switchTheme.borderColor?.resolve(selectedDisabledState) ??
            defaultBorderColor;
    final disabledCheckedThumbColor =
        switchTheme.thumbColor?.resolve(selectedDisabledState) ??
            disabledUncheckedThumbColor;

    // Indicator colors
    final hoverIndicatorColor =
        switchTheme.indicatorColor?.resolve({MaterialState.hovered}) ??
            painter.hoverIndicatorColor;
    final focusIndicatorColor =
        switchTheme.indicatorColor?.resolve({MaterialState.focused}) ??
            painter.focusIndicatorColor;

    return _maybeBuildGestureDetector(
      buildToggleable(
        painter
          ..uncheckedColor = uncheckedColor
          ..uncheckedBorderColor = uncheckedBorderColor
          ..uncheckedThumbColor = uncheckedThumbColor
          ..checkedColor = checkedColor
          ..checkedBorderColor = checkedBorderColor
          ..checkedThumbColor = checkedThumbColor
          ..disabledUncheckedColor = disabledUncheckedColor
          ..disabledUncheckedBorderColor = disabledUncheckedBorderColor
          ..disabledUncheckedThumbColor = disabledUncheckedThumbColor
          ..disabledCheckedColor = disabledCheckedColor
          ..disabledCheckedBorderColor = disabledCheckedBorderColor
          ..disabledCheckedThumbColor = disabledCheckedThumbColor
          ..hoverIndicatorColor = hoverIndicatorColor
          ..focusIndicatorColor = focusIndicatorColor,
        mouseCursor: widget.mouseCursor ??
            switchTheme.mouseCursor
                ?.resolve({if (!widget.interactive) MaterialState.disabled}),
      ),
    );
  }

  Widget _maybeBuildGestureDetector(Widget child) {
    if (!widget.interactive) {
      return child;
    }

    return GestureDetector(
      onPanStart: (details) {
        final thumbSize = _kSwitchSize.height * _kSwitchThumbSizeFactor;
        final thumbGap = (_kSwitchSize.height - thumbSize) / 2;

        final minDragX = widget.value
            ? _kSwitchSize.width - (thumbGap + thumbSize)
            : thumbGap;
        final maxDragX =
            widget.value ? _kSwitchSize.width - thumbGap : thumbGap + thumbSize;

        if (details.localPosition.dx >= minDragX &&
            details.localPosition.dx <= maxDragX) {
          setState(() {
            isDragging = true;
            handleActiveChange(true);
          });
        }
      },
      onPanUpdate: (details) {
        if (!isDragging) {
          return;
        }

        final thumbSize = _kSwitchSize.height * _kSwitchThumbSizeFactor;
        final thumbGap = (_kSwitchSize.height - thumbSize) / 2;
        final dragGap = thumbGap + thumbSize / 2;
        final innerWidth = _kSwitchSize.width - dragGap * 2;

        positionController.value =
            (details.localPosition.dx - dragGap) / innerWidth;
      },
      onPanEnd: (details) {
        if (!isDragging) {
          return;
        }

        setState(() {
          isDragging = false;
          handleActiveChange(false);

          if (positionController.value < .5) {
            if (widget.value != false) {
              widget.onChanged!(false);
            }
            positionController.animateTo(0);
          } else {
            if (widget.value != true) {
              widget.onChanged!(true);
            }
            positionController.animateTo(1);
          }
        });
      },
      child: child,
    );
  }
}

class _YaruSwitchPainter extends YaruTogglablePainter {
  late Color uncheckedThumbColor;
  late Color checkedThumbColor;
  late Color disabledCheckedThumbColor;
  late Color disabledUncheckedThumbColor;

  @override
  void paintTogglable(
    Canvas canvas,
    Size realSize,
    Size size,
    Offset origin,
    double t,
  ) {
    _drawBox(canvas, size, origin, t);
    _drawThumb(canvas, size, origin, t);
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
            : Color.lerp(disabledUncheckedColor, disabledCheckedColor, t)!
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          origin.dx + 0.5,
          origin.dy + 0.5,
          size.width - 1.0,
          size.height - 1.0,
        ),
        Radius.circular(size.height),
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

  void _drawThumb(Canvas canvas, Size size, Offset origin, double t) {
    final margin = (size.height - size.height * _kSwitchThumbSizeFactor) / 2;
    final innerSize = Size(
      size.width - margin * 2,
      size.height - margin * 2,
    );
    final radius = innerSize.height / 2;

    final start = Offset(radius + margin, radius + margin);
    final end = Offset(innerSize.width + margin - radius, radius + margin);
    final center = Offset.lerp(start, end, t)! + origin;

    final paint = Paint()
      ..color = interactive
          ? Color.lerp(uncheckedThumbColor, checkedThumbColor, t)!
          : Color.lerp(
              disabledUncheckedThumbColor,
              disabledCheckedThumbColor,
              t,
            )!
      ..style = PaintingStyle.fill;

    drawStateIndicator(canvas, size, center);
    canvas.drawCircle(center, radius, paint);
  }
}
