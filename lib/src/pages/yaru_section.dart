import 'package:flutter/material.dart';
import '../constants.dart';

class YaruSection extends StatelessWidget {
  /// Creates a yaru style section widget with multiple
  /// [Widgets] as children.
  const YaruSection({
    super.key,
    this.headline,
    required this.child,
    this.width,
    this.headerWidget,
    this.padding = const EdgeInsets.only(bottom: 20.0),
  });

  /// Widget that is placed above the list of `children`.
  final Widget? headline;

  /// The child widget inside the section.
  final Widget child;

  /// Specifies the [width] of the [Container].
  /// By default the width will be 500.
  final double? width;

  /// Aligns the widget horizontally along with headline.
  ///
  /// Both `headline` and `headerWidget` will be aligned horizontally
  /// with [mainAxisAlignment] as [MainAxisAlignment.spaceBetween].
  final Widget? headerWidget;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.only(bottom: 20.0)`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(kYaruContainerRadius),
            ),
          ),
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
        ),
      ),
    );
  }
}
