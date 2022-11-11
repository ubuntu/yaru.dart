import 'package:flutter/material.dart';
import '../utilities/yaru_border_container.dart';

class YaruSection extends StatelessWidget {
  /// Creates a yaru style section widget with multiple
  /// [Widgets] as children.
  const YaruSection({
    super.key,
    this.title,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8.0),
    this.titlePadding = const EdgeInsets.all(8.0),
    this.margin,
  });

  /// Widget that is placed above the `child`.
  final Widget? title;

  /// The child widget inside the section.
  final Widget child;

  /// Specifies the [width] of the section.
  final double? width;

  /// Specifies the [height] of the section.
  final double? height;

  /// The padding between the section border and its [child] which defaults to
  /// `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  /// The padding around the [title] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets titlePadding;

  /// An optional margin around the section border.
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: titlePadding,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: title!,
              ),
            ),
          child,
        ],
      ),
    );
  }
}
