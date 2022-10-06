import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../constants.dart';

const double _kPanelHeaderCollapsedHeight = 48.0;
const double _kPanelHeaderExpandedHeight = 64.0;

/// A decorated [ExpansionPanelList]
class YaruExpansionPanelList extends StatelessWidget {
  const YaruExpansionPanelList({
    super.key,
    this.children = const <ExpansionPanel>[],
    required this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation,
    this.customExpandIconData,
  });

  final List<ExpansionPanel> children;

  final ExpansionPanelCallback expansionCallback;

  final Duration animationDuration;

  final double? elevation;

  final IconData? customExpandIconData;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    const kExpandedEdgeInsets = EdgeInsets.symmetric(
      vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight,
    );

    for (var index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(
          Divider(
            key: _SaltedKey<BuildContext, int>(context, index * 2 - 1),
            height: 10.0,
            color: Colors.transparent,
          ),
        );
      }

      final header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index)
                  ? kExpandedEdgeInsets
                  : EdgeInsets.zero,
              child: SizedBox(
                height: _kPanelHeaderCollapsedHeight,
                child: children[index].headerBuilder(
                  context,
                  children[index].isExpanded,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 8.0),
            child: YaruExpandIcon(
              customExpandIconData: customExpandIconData,
              isExpanded: _isChildExpanded(index),
              padding: const EdgeInsets.all(16.0),
              onPressed: (isExpanded) {
                expansionCallback(index, isExpanded);
              },
            ),
          ),
        ],
      );

      const _radiusValue = kYaruContainerRadius;
      final borderRadius = index == 0
          ? const BorderRadius.only(
              topLeft: Radius.circular(_radiusValue),
              topRight: Radius.circular(_radiusValue),
            )
          : index == children.length - 1
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(_radiusValue),
                  bottomRight: Radius.circular(_radiusValue),
                )
              : BorderRadius.zero;
      items.add(
        Container(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          child: Material(
            elevation: elevation ?? 2,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: () => expansionCallback(index, _isChildExpanded(index)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: header,
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(height: 0.0),
                    secondChild: children[index].body,
                    firstCurve:
                        const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                    secondCurve:
                        const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                    sizeCurve: Curves.fastOutSlowIn,
                    crossFadeState: _isChildExpanded(index)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: animationDuration,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (index != children.length - 1 && _isChildExpanded(index)) {
        items.add(
          SizedBox(
            height: 10,
            key: _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          ),
        );
      }
    }

    return Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

/// [ExpandIcon] with an optional [customExpandIconData]
/// Copyright 2014 The Flutter Authors. All rights reserved.
class YaruExpandIcon extends StatefulWidget {
  /// Creates an [YaruExpandIcon] with the given padding, and a callback that is
  /// triggered when the icon is pressed.
  const YaruExpandIcon({
    super.key,
    this.isExpanded = false,
    this.size = 24.0,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
    this.disabledColor,
    this.expandedColor,
    this.customExpandIconData,
  });

  /// Whether the icon is in an expanded state.
  ///
  /// Rebuilding the widget with a different [isExpanded] value will trigger
  /// the animation, but will not trigger the [onPressed] callback.
  final bool isExpanded;

  /// The size of the icon.
  ///
  /// This property must not be null. It defaults to 24.0.
  final double size;

  /// The callback triggered when the icon is pressed and the state changes
  /// between expanded and collapsed. The value passed to the current state.
  ///
  /// If this is set to null, the button will be disabled.
  final ValueChanged<bool>? onPressed;

  /// The padding around the icon. The entire padded icon will react to input
  /// gestures.
  ///
  /// This property must not be null. It defaults to 8.0 padding on all sides.
  final EdgeInsetsGeometry padding;

  /// The color of the icon.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white60] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? color;

  /// The color of the icon when it is disabled,
  /// i.e. if [onPressed] is null.
  ///
  /// Defaults to [Colors.black38] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white38] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? disabledColor;

  /// The color of the icon when the icon is expanded.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? expandedColor;

  final IconData? customExpandIconData;

  @override
  State<YaruExpandIcon> createState() => _YaruExpandIconState();
}

class _YaruExpandIconState extends State<YaruExpandIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  static final Animatable<double> _iconTurnTween =
      Tween<double>(begin: 0.0, end: 0.5)
          .chain(CurveTween(curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);
    // If the widget is initially expanded, rotate the icon without animating it.
    if (widget.isExpanded) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(YaruExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePressed() {
    widget.onPressed?.call(widget.isExpanded);
  }

  /// Default icon colors and opacities for when [Theme.brightness] is set to
  /// [Brightness.light] are based on the
  /// [Material Design system icon specifications](https://material.io/design/iconography/system-icons.html#color).
  /// Icon colors and opacities for [Brightness.dark] are based on the
  /// [Material Design dark theme specifications](https://material.io/design/color/dark-theme.html#ui-application)
  Color get _iconColor {
    if (widget.isExpanded && widget.expandedColor != null) {
      return widget.expandedColor!;
    }

    if (widget.color != null) {
      return widget.color!;
    }

    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white60;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final localizations = MaterialLocalizations.of(context);
    final onTapHint = widget.isExpanded
        ? localizations.expandedIconTapHint
        : localizations.collapsedIconTapHint;

    return Semantics(
      onTapHint: widget.onPressed == null ? null : onTapHint,
      child: IconButton(
        splashRadius: 20,
        padding: widget.padding,
        iconSize: widget.size,
        color: _iconColor,
        disabledColor: widget.disabledColor,
        onPressed: widget.onPressed == null ? null : _handlePressed,
        icon: RotationTransition(
          turns: _iconTurns,
          child: Icon(widget.customExpandIconData ?? Icons.expand_more),
        ),
      ),
    );
  }
}
