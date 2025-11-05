import 'package:flutter/material.dart';
import 'package:yaru/constants.dart';

enum _YaruFocusBorderVariant { primary, secondary, onSurface }

/// Padding between the border and child widget.
class YaruFocusBorderPadding {
  static const zero = EdgeInsetsGeometry.zero;
  static const small = EdgeInsets.all(2);
  static const medium = EdgeInsets.all(4);
  static const large = EdgeInsets.all(6);
}

/// Draws a border around the child widget when focused.
class YaruFocusBorder extends StatefulWidget {
  YaruFocusBorder({
    required this.child,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.borderStrokeAlign,
    this.borderPadding,
    this.focused,
    this.onFocusChange,
  }) : _variant = _YaruFocusBorderVariant.primary;

  const YaruFocusBorder.primary({
    required this.child,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.borderStrokeAlign,
    this.borderPadding,
    this.focused,
    this.onFocusChange,
  }) : _variant = _YaruFocusBorderVariant.primary;

  const YaruFocusBorder.secondary({
    required this.child,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.borderStrokeAlign,
    this.borderPadding,
    this.focused,
    this.onFocusChange,
  }) : _variant = _YaruFocusBorderVariant.secondary;

  const YaruFocusBorder.onSurface({
    required this.child,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.borderStrokeAlign,
    this.borderPadding,
    this.focused,
    this.onFocusChange,
  }) : _variant = _YaruFocusBorderVariant.onSurface;

  final _YaruFocusBorderVariant _variant;
  final Widget child;

  /// See [BoxDecoration.borderRadius]
  final BorderRadiusGeometry? borderRadius;

  /// See [BoxDecoration.color]
  final Color? borderColor;

  /// See [BorderSide.width]
  final double? borderWidth;

  /// See [BorderSide.strokeAlign]
  final double? borderStrokeAlign;

  /// See [AnimatedContainer.padding]
  final EdgeInsetsGeometry? borderPadding;

  /// Whether the child is focused or not.
  final bool? focused;

  /// Callback called when the focus changes.
  final void Function(bool)? onFocusChange;

  @override
  State<YaruFocusBorder> createState() => _YaruFocusBorderState();
}

class _YaruFocusBorderState extends State<YaruFocusBorder> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focused = widget.focused ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderColor =
        widget.borderColor ??
        switch (widget._variant) {
          _YaruFocusBorderVariant.primary => theme.colorScheme.primary,
          _YaruFocusBorderVariant.secondary => theme.colorScheme.secondary,
          _YaruFocusBorderVariant.onSurface => theme.colorScheme.onSurface,
        };

    return AnimatedContainer(
      duration: Durations.medium1,
      padding: widget.borderPadding ?? YaruFocusBorderPadding.zero,
      foregroundDecoration: BoxDecoration(
        border: BoxBorder.all(
          strokeAlign: widget.borderStrokeAlign ?? 3,
          color: _focused ? borderColor : Colors.transparent,
          width: widget.borderWidth ?? kYaruBorderWidth,
        ),
        borderRadius:
            widget.borderRadius ??
            const BorderRadius.all(Radius.circular(kYaruButtonRadius + 2)),
      ),
      child: InkWell(
        onFocusChange: (value) => widget.onFocusChange != null
            ? widget.onFocusChange!(value)
            : setState(() {
                _focused = value;
              }),
        child: widget.child,
      ),
    );
  }
}
