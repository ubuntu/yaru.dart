import 'package:flutter/material.dart';

import '../constants.dart';

/// A container with a rounded Yaru-style border.
class YaruBorderContainer extends StatelessWidget {
  /// Creates a [YaruBorderContainer].
  const YaruBorderContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
    this.border,
    this.borderRadius,
  });

  /// See [Container.child].
  final Widget? child;

  /// See [Container.alignment].
  final AlignmentGeometry? alignment;

  /// See [Container.padding].
  final EdgeInsetsGeometry? padding;

  /// See [Container.color].
  final Color? color;

  /// See [Container.width].
  final double? width;

  /// See [Container.height].
  final double? height;

  /// See [Container.constraints].
  final BoxConstraints? constraints;

  /// See [Container.margin].
  final EdgeInsetsGeometry? margin;

  /// See [Container.transform].
  final Matrix4? transform;

  /// See [Container.transformAlignment].
  final AlignmentGeometry? transformAlignment;

  /// See [Container.clipBehavior].
  final Clip clipBehavior;

  /// The border.
  ///
  /// The default border is 1px wide and the color is [ThemeData.dividerColor].
  final BoxBorder? border;

  /// The border radius.
  ///
  /// The default border is circular with the radius of `kYaruContainerRadius`.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorder = border ??
        Border.all(color: DividerTheme.of(context).color ?? theme.dividerColor);
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(kYaruContainerRadius);

    return Container(
      alignment: alignment,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      padding: padding,
      height: height,
      width: width,
      foregroundDecoration: BoxDecoration(
        border: effectiveBorder,
        borderRadius: effectiveBorderRadius,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: effectiveBorderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
