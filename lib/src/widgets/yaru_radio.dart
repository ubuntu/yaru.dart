import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_togglable.dart';

// NOTE: keep in sync with Checkbox
const _kRadioActivableAreaPadding = EdgeInsets.all(6);
const _kRadioTogglableSize = Size.square(20);

const _kDotSizeFactor = 0.4;

/// A Yaru radio.
///
/// Used to select between a number of mutually exclusive values. When one radio
/// button in a group is selected, the other radio buttons in the group cease to
/// be selected. The values are of type [T], the type parameter of the [YaruRadio]
/// class. Enums are commonly used for this purpose.
///
/// The radio button itself does not maintain any state. Instead, selecting the
/// radio invokes the [onChanged] callback, passing [value] as a parameter. If
/// [groupValue] and [value] match, this radio will be selected. Most widgets
/// will respond to [onChanged] by calling [State.setState] to update the
/// radio button's [groupValue].
///
/// See also:
///
///  * [YaruRadioButton], a desktop style radio button with an interactive label.
///  * [Slider], for selecting a value in a range.
///  * [YaruCheckbox] and [YaruSwitch], for toggling a particular value on or off.
class YaruRadio<T> extends StatefulWidget implements YaruTogglable<T?> {
  /// Create a Yaru radio.
  ///
  /// The radio button itself does not maintain any state. Instead, selecting the
  /// radio invokes the [onChanged] callback, passing [value] as a parameter. If
  /// [groupValue] and [value] match, this radio will be selected. Most widgets
  /// will respond to [onChanged] by calling [State.setState] to update the
  /// radio button's [groupValue].
  const YaruRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.toggleable = false,
    required this.onChanged,
    this.selectedColor,
    this.checkmarkColor,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.statesController,
    this.hasFocusBorder,
  }) : assert(toggleable || value != null);

  /// The value represented by this radio button.
  @override
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  @override
  bool get checked => value == groupValue;

  /// Set to true if this radio button is allowed to be returned to an
  /// indeterminate state by selecting it again when selected.
  ///
  /// To indicate returning to an indeterminate state, [onChanged] will be
  /// called with null.
  ///
  /// If true, [onChanged] can be called with [value] when selected while
  /// [groupValue] != [value], or with null when selected again while
  /// [groupValue] == [value].
  ///
  /// If false, [onChanged] will be called with [value] when it is selected
  /// while [groupValue] != [value], and only by selecting another radio button
  /// in the group (i.e. changing the value of [groupValue]) can this radio
  /// button be unselected.
  ///
  /// The default is false.
  final bool toggleable;

  @override
  bool get tristate => toggleable;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// YaruRadio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  @override
  final ValueChanged<T?>? onChanged;

  /// The color to use when this radio is checked.
  ///
  /// Defaults to [ColorScheme.primary].
  final Color? selectedColor;

  /// The color to use for the checkmark when this radio is checked.
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
      FlagProperty(
        'value',
        value: checked,
        ifTrue: 'selected',
        ifFalse: 'unselected',
      ),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<T?>>(
        'onChanged',
        onChanged,
        ifNull: 'disabled',
      ),
    );
  }

  @override
  YaruTogglableState<YaruRadio<T?>> createState() {
    return _YaruRadioState<T?>();
  }
}

class _YaruRadioState<T> extends YaruTogglableState<YaruRadio<T?>> {
  @override
  EdgeInsetsGeometry get activableAreaPadding => _kRadioActivableAreaPadding;

  @override
  Size get togglableSize => _kRadioTogglableSize;

  @override
  void handleTap([Intent? _]) {
    if (!widget.interactive) {
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
    final radioTheme = YaruRadioTheme.of(context);
    final painter = _YaruRadioPainter();
    fillPainterDefaults(painter);

    const unselectedState = <WidgetState>{};
    const selectedState = {WidgetState.selected};
    const disabledState = {WidgetState.disabled};
    const selectedDisabledState = {WidgetState.selected, WidgetState.disabled};

    // Normal colors
    final uncheckedColor =
        radioTheme.color?.resolve(unselectedState) ?? painter.uncheckedColor;
    final uncheckedBorderColor =
        radioTheme.borderColor?.resolve(unselectedState) ??
        painter.uncheckedBorderColor;
    final checkedColor =
        widget.selectedColor ??
        radioTheme.color?.resolve(selectedState) ??
        painter.checkedColor;
    final checkmarkColor =
        widget.checkmarkColor ??
        radioTheme.checkmarkColor?.resolve(selectedState) ??
        painter.checkmarkColor;

    // Disabled colors
    final disabledUncheckedColor =
        radioTheme.color?.resolve(disabledState) ??
        painter.disabledUncheckedColor;
    final disabledUncheckedBorderColor =
        radioTheme.borderColor?.resolve(disabledState) ??
        painter.disabledUncheckedBorderColor;
    final disabledCheckedColor =
        radioTheme.color?.resolve(selectedDisabledState) ??
        painter.disabledCheckedColor;
    final disabledCheckmarkColor =
        radioTheme.checkmarkColor?.resolve(selectedDisabledState) ??
        painter.disabledCheckmarkColor;

    // Indicator colors
    final hoverIndicatorColor =
        radioTheme.indicatorColor?.resolve({WidgetState.hovered}) ??
        painter.hoverIndicatorColor;
    final focusIndicatorColor =
        radioTheme.indicatorColor?.resolve({WidgetState.focused}) ??
        painter.focusIndicatorColor;

    final radioWidth = buildToggleable(
      painter
        ..uncheckedColor = uncheckedColor
        ..uncheckedBorderColor = uncheckedBorderColor
        ..checkedColor = checkedColor
        ..checkmarkColor = checkmarkColor
        ..disabledUncheckedColor = disabledUncheckedColor
        ..disabledUncheckedBorderColor = disabledUncheckedBorderColor
        ..disabledCheckedColor = disabledCheckedColor
        ..disabledCheckmarkColor = disabledCheckmarkColor
        ..hoverIndicatorColor = hoverIndicatorColor
        ..focusIndicatorColor = focusIndicatorColor,
      mouseCursor:
          widget.mouseCursor ??
          radioTheme.mouseCursor?.resolve({
            if (!widget.interactive) WidgetState.disabled,
          }),
    );

    return widget.hasFocusBorder ??
            YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(
            borderRadius: BorderRadius.circular(100),
            child: radioWidth,
          )
        : radioWidth;
  }
}

class _YaruRadioPainter extends YaruTogglablePainter {
  @override
  void paintTogglable(Canvas canvas, Size size, double t) {
    drawStateIndicator(canvas, size);
    _drawBox(canvas, size, t);
    _drawDot(canvas, size, t);
  }

  void _drawBox(Canvas canvas, Size size, double t) {
    canvas.drawOval(
      Offset.zero & size,
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(disabledUncheckedColor, disabledCheckedColor, t)!
        ..style = PaintingStyle.fill,
    );

    canvas.drawOval(
      Rect.fromLTWH(0.5, 0.5, size.width - 1.0, size.height - 1.0),
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

  void _drawDot(Canvas canvas, Size size, double t) {
    final center = (Offset.zero & size).center;
    final dotSize = size * _kDotSizeFactor;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: dotSize.width * t,
        height: dotSize.height * t,
      ),
      Paint()
        ..color = interactive ? checkmarkColor : disabledCheckmarkColor
        ..style = PaintingStyle.fill,
    );
  }
}
