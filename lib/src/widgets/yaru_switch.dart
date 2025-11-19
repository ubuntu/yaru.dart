import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_togglable.dart';

const _kSwitchActivableAreaPadding = EdgeInsets.symmetric(
  horizontal: 2,
  vertical: 5,
);
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
    this.onOffShapes,
    this.hasFocusBorder,
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

  /// Whether to draw on/off shapes or not.
  final bool? onOffShapes;

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
      FlagProperty('value', value: checked, ifTrue: 'on', ifFalse: 'off'),
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
  double gestureDeltaDx = 0.0;

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
    final settings = YaruTheme.maybeOf(context);
    final painter = _YaruSwitchPainter(
      onOffShapes: widget.onOffShapes ?? settings?.statusShapes,
    );
    fillPainterDefaults(painter);

    const unselectedState = <WidgetState>{};
    const selectedState = {WidgetState.selected};
    const disabledState = {WidgetState.disabled};
    const selectedDisabledState = {WidgetState.selected, WidgetState.disabled};

    final defaultBorderColor = colorScheme.isHighContrast && widget.interactive
        ? colorScheme.outlineVariant
        : Colors.transparent;

    // Normal colors
    final uncheckedColor =
        switchTheme.color?.resolve(unselectedState) ??
        colorScheme.onSurface.withValues(alpha: 0.25);
    final uncheckedBorderColor =
        switchTheme.borderColor?.resolve(unselectedState) ?? defaultBorderColor;
    final uncheckedThumbColor =
        switchTheme.thumbColor?.resolve(unselectedState) ?? Colors.white;
    final checkedColor =
        widget.selectedColor ??
        switchTheme.color?.resolve(selectedState) ??
        painter.checkedColor;
    final checkedBorderColor =
        switchTheme.borderColor?.resolve(selectedState) ?? defaultBorderColor;
    final checkedThumbColor =
        widget.thumbColor ??
        switchTheme.thumbColor?.resolve(selectedState) ??
        painter.checkmarkColor;
    final checkedThumbBorderColor = colorScheme.isLight
        ? checkedBorderColor
        : checkedThumbColor;
    final uncheckedThumbBorderColor = colorScheme.isLight
        ? uncheckedBorderColor
        : uncheckedThumbColor;
    final checkedShapeColor = checkedThumbColor;
    final uncheckedShapeColor = colorScheme.isLight
        ? colorScheme.outlineVariant
        : uncheckedThumbColor;

    // Disabled colors
    final disabledUncheckedColor =
        switchTheme.color?.resolve(disabledState) ??
        painter.disabledUncheckedColor;
    final disabledUncheckedBorderColor =
        switchTheme.borderColor?.resolve(disabledState) ?? defaultBorderColor;
    final disabledUncheckedThumbColor =
        switchTheme.thumbColor?.resolve(disabledState) ??
        colorScheme.onSurface.withValues(alpha: 0.4);
    final disabledCheckedColor =
        switchTheme.color?.resolve(selectedDisabledState) ??
        painter.disabledCheckedColor;
    final disabledCheckedBorderColor =
        switchTheme.borderColor?.resolve(selectedDisabledState) ??
        defaultBorderColor;
    final disabledCheckedThumbColor =
        switchTheme.thumbColor?.resolve(selectedDisabledState) ??
        disabledUncheckedThumbColor;
    final disabledCheckedShapeColor = disabledCheckedThumbColor;
    final disabledUncheckedShapeColor = colorScheme.isLight
        ? colorScheme.outlineVariant.withValues(alpha: 0.4)
        : disabledUncheckedThumbColor;

    // Indicator colors
    final hoverIndicatorColor =
        switchTheme.indicatorColor?.resolve({WidgetState.hovered}) ??
        painter.hoverIndicatorColor;
    final focusIndicatorColor =
        switchTheme.indicatorColor?.resolve({WidgetState.focused}) ??
        painter.focusIndicatorColor;

    final switchWidget = _maybeBuildGestureDetector(
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
          ..focusIndicatorColor = focusIndicatorColor
          ..checkedThumbBorderColor = checkedThumbBorderColor
          ..uncheckedThumbBorderColor = uncheckedThumbBorderColor
          ..checkedShapeColor = checkedShapeColor
          ..uncheckedShapeColor = uncheckedShapeColor
          ..disabledCheckedShapeColor = disabledCheckedShapeColor
          ..disabledUncheckedShapeColor = disabledUncheckedShapeColor,
        mouseCursor:
            widget.mouseCursor ??
            switchTheme.mouseCursor?.resolve({
              if (!widget.interactive) WidgetState.disabled,
            }),
      ),
    );

    return widget.hasFocusBorder ??
            YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(child: switchWidget)
        : switchWidget;
  }

  Widget _maybeBuildGestureDetector(Widget child) {
    if (!widget.interactive) {
      return child;
    }

    final thumbSize = _kSwitchSize.height * _kSwitchThumbSizeFactor;
    final thumbGap = (_kSwitchSize.height - thumbSize) / 2;
    final innerWidth = _kSwitchSize.width - thumbGap * 2;

    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          gestureDeltaDx = positionController.value * (innerWidth - thumbSize);
          isDragging = true;
          handleActiveChange(true);
          handleHoverChange(true);
        });
      },
      onPanUpdate: (details) {
        if (!isDragging) {
          return;
        }
        gestureDeltaDx += details.delta.dx;
        positionController.value = gestureDeltaDx / (innerWidth - thumbSize);
        handleActiveChange(true);
        handleHoverChange(true);
      },
      onPanEnd: (details) {
        if (!isDragging) {
          return;
        }

        setState(() {
          isDragging = false;
          handleActiveChange(false);
          handleHoverChange(false);

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
  _YaruSwitchPainter({this.onOffShapes});

  late Color uncheckedThumbColor;
  late Color checkedThumbColor;
  late Color disabledCheckedThumbColor;
  late Color disabledUncheckedThumbColor;
  late Color uncheckedThumbBorderColor;
  late Color checkedThumbBorderColor;
  late Color checkedShapeColor;
  late Color uncheckedShapeColor;
  late Color disabledCheckedShapeColor;
  late Color disabledUncheckedShapeColor;

  final bool? onOffShapes;

  @override
  void paintTogglable(Canvas canvas, Size size, double t) {
    _drawBox(canvas, size, t);
    _drawThumb(canvas, size, t);
    if (onOffShapes == true) {
      _drawOnOffShapes(canvas, size, t);
    }
  }

  void _drawBox(Canvas canvas, Size size, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(size.height)),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(disabledUncheckedColor, disabledCheckedColor, t)!
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.5, 0.5, size.width - 1.0, size.height - 1.0),
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

  void _drawThumb(Canvas canvas, Size size, double t) {
    final margin = (size.height - size.height * _kSwitchThumbSizeFactor) / 2;
    final innerSize = Size(size.width - margin * 2, size.height - margin * 2);
    final radius = innerSize.height / 2;

    final start = Offset(radius + margin, radius + margin);
    final end = Offset(innerSize.width + margin - radius, radius + margin);
    final center = Offset.lerp(start, end, t)!;

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

    canvas.drawCircle(
      center,
      radius - 0.5,
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedThumbBorderColor, checkedThumbColor, t)!
            : Colors.transparent
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawOnOffShapes(Canvas canvas, Size size, double t) {
    final margin = (size.height - size.height * _kSwitchThumbSizeFactor) / 2;
    final innerSize = Size(size.width - margin * 2, size.height - margin * 2);
    final shapeColor = interactive
        ? Color.lerp(uncheckedShapeColor, checkedShapeColor, t)!
        : Color.lerp(
            disabledUncheckedShapeColor,
            disabledCheckedShapeColor,
            t,
          )!;

    if (t == 1) {
      // on |
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset((size.width - innerSize.height) / 2, size.height / 2),
          width: 2,
          height: size.height / 2.5,
        ),
        Paint()
          ..color = shapeColor
          ..style = PaintingStyle.fill,
      );
    } else {
      // off o
      canvas.drawCircle(
        Offset(
          innerSize.height + ((size.width - innerSize.height) / 2),
          size.height / 2,
        ),
        size.height / 7,
        Paint()
          ..color = shapeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }
}
