import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'yaru_checkbox.dart';
import 'yaru_radio.dart';
import 'yaru_switch_button.dart';
import 'yaru_switch_theme.dart';
import 'yaru_togglable.dart';

const _kSwitchActivableAreaPadding =
    EdgeInsets.symmetric(horizontal: 2, vertical: 5);
const _kSwitchSize = Size(55, 30);
const _kSwitchDotSizeFactor = 0.8;

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
    this.dotColor,
    this.checkmarkColor,
    this.focusNode,
    this.autofocus = false,
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

  /// The color to use for the dot when this switch is on.
  ///
  /// Defaults to [ColorScheme.onPrimary].
  final Color? dotColor;

  /// The color to use for the dot when this switch is on.
  ///
  /// Defaults to [ColorScheme.onPrimary].
  @Deprecated('Use `dotColor` instead. Will be removed in yaru_widgets 3.0.0')
  final Color? checkmarkColor;

  @override
  bool get interactive => onChanged != null;

  /// {@macro flutter.widgets.Focus.focusNode}
  @override
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  @override
  final bool autofocus;

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
      MaterialState.disabled
    };

    // Normal colors
    final uncheckedColor = switchTheme.color?.resolve(unselectedState) ??
        colorScheme.onSurface.withOpacity(.25);
    final uncheckedBorderColor =
        switchTheme.borderColor?.resolve(unselectedState) ?? Colors.transparent;
    final uncheckedDotColor =
        switchTheme.dotColor?.resolve(unselectedState) ?? Colors.white;
    final checkedColor = widget.selectedColor ??
        switchTheme.color?.resolve(selectedState) ??
        painter.checkedColor;
    final checkedBorderColor =
        switchTheme.borderColor?.resolve(selectedState) ?? Colors.transparent;
    final checkedDotColor = widget.dotColor ??
        // ignore: deprecated_member_use_from_same_package
        widget.checkmarkColor ??
        switchTheme.dotColor?.resolve(selectedState) ??
        painter.checkmarkColor;

    // Disabled colors
    final disabledUncheckedColor = switchTheme.color?.resolve(disabledState) ??
        painter.disabledUncheckedColor;
    final disabledUncheckedBorderColor =
        switchTheme.borderColor?.resolve(disabledState) ?? Colors.transparent;
    final disabledUncheckedDotColor =
        switchTheme.dotColor?.resolve(disabledState) ??
            colorScheme.onSurface.withOpacity(.4);
    final disabledCheckedColor =
        switchTheme.color?.resolve(selectedDisabledState) ??
            painter.disabledCheckedColor;
    final disabledCheckedBorderColor =
        switchTheme.borderColor?.resolve(selectedDisabledState) ??
            Colors.transparent;
    final disabledCheckedDotColor =
        switchTheme.dotColor?.resolve(selectedDisabledState) ??
            disabledUncheckedDotColor;

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
          ..uncheckedDotColor = uncheckedDotColor
          ..checkedColor = checkedColor
          ..checkedBorderColor = checkedBorderColor
          ..checkedDotColor = checkedDotColor
          ..disabledUncheckedColor = disabledUncheckedColor
          ..disabledUncheckedBorderColor = disabledUncheckedBorderColor
          ..disabledUncheckedDotColor = disabledUncheckedDotColor
          ..disabledCheckedColor = disabledCheckedColor
          ..disabledCheckedBorderColor = disabledCheckedBorderColor
          ..disabledCheckedDotColor = disabledCheckedDotColor
          ..hoverIndicatorColor = hoverIndicatorColor
          ..focusIndicatorColor = focusIndicatorColor,
      ),
    );
  }

  Widget _maybeBuildGestureDetector(Widget child) {
    if (!widget.interactive) {
      return child;
    }

    return GestureDetector(
      onPanStart: (details) {
        final dotSize = _kSwitchSize.height * _kSwitchDotSizeFactor;
        final dotGap = (_kSwitchSize.height - dotSize) / 2;

        final minDragX =
            widget.value ? _kSwitchSize.width - (dotGap + dotSize) : dotGap;
        final maxDragX =
            widget.value ? _kSwitchSize.width - dotGap : dotGap + dotSize;

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

        final dotSize = _kSwitchSize.height * _kSwitchDotSizeFactor;
        final dotGap = (_kSwitchSize.height - dotSize) / 2;
        final dragGap = dotGap + dotSize / 2;
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
  late Color uncheckedDotColor;
  late Color checkedDotColor;
  late Color disabledCheckedDotColor;
  late Color disabledUncheckedDotColor;

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
      ..color = interactive
          ? Color.lerp(uncheckedDotColor, checkedDotColor, t)!
          : Color.lerp(disabledUncheckedDotColor, disabledCheckedDotColor, t)!
      ..style = PaintingStyle.fill;

    drawStateIndicator(canvas, size, center);
    canvas.drawCircle(center, radius, paint);
  }
}
