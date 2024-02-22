import 'package:flutter/material.dart';

import 'yaru_border_container.dart';

class YaruSection extends StatelessWidget {
  /// Creates a yaru style section widget with multiple
  /// [Widgets] as children.
  const YaruSection({
    super.key,
    this.headline,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8.0),
    this.headlinePadding = const EdgeInsets.all(8.0),
    this.margin,
  });

  /// Widget that is placed above the `child`.
  final Widget? headline;

  /// The child widget inside the section.
  final Widget child;

  /// Specifies the [width] of the section.
  final double? width;

  /// Specifies the [height] of the section.
  final double? height;

  /// The padding between the section border and its [child] which defaults to
  /// `EdgeInsets.all(8.0)`.
  final EdgeInsetsGeometry padding;

  /// The padding around the [headline] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsetsGeometry headlinePadding;

  /// An optional margin around the section border.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headline != null)
            Padding(
              padding: headlinePadding,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: headline!,
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
