import 'package:flutter/material.dart';
import '../utilities/yaru_border_container.dart';

class YaruSection extends StatelessWidget {
  /// Creates a yaru style section widget with multiple
  /// [Widgets] as children.
  const YaruSection({
    super.key,
    this.headline,
    required this.child,
    this.width,
    this.height,
    this.headerWidget,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
  });

  /// Widget that is placed above the list of `children`.
  final Widget? headline;

  /// The child widget inside the section.
  final Widget child;

  /// Specifies the [width] of the section.
  final double? width;

  /// Specifies the [height] of the section.
  final double? height;

  /// Aligns the widget horizontally along with headline.
  ///
  /// Both `headline` and `headerWidget` will be aligned horizontally
  /// with [mainAxisAlignment] as [MainAxisAlignment.spaceBetween].
  final Widget? headerWidget;

  /// The padding between the section border and its [child] which defaults to
  /// `EdgeInsets.only(all: 8.0)`.
  final EdgeInsets padding;

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
        children: [
          Padding(
            padding: EdgeInsets.all(headline != null ? 8.0 : 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (headline != null)
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleLarge!,
                      textAlign: TextAlign.left,
                      child: headline!,
                    ),
                  headerWidget ?? const SizedBox()
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
