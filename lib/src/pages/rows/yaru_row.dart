import 'package:flutter/material.dart';

class YaruRow extends StatelessWidget {
  /// Creates a Yaru style [ListTile] similar widget.
  ///
  /// for example:
  /// ```dart
  ///     YaruRow(
  ///        trailingWidget: Text('trailingWidget'),
  ///        actionWidget: Text('actionWidget'),
  ///        description: 'description',
  ///       );
  /// ```
  const YaruRow({
    super.key,
    this.leadingWidget,
    required this.trailingWidget,
    this.description,
    required this.actionWidget,
    this.enabled = true,
    this.width,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
  });

  /// The [Widget] placed at the leading position.
  /// A widget to display before the [trailingWidget].
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leadingWidget;

  /// The [Widget] placed at trailing position.
  final Widget trailingWidget;

  /// The Description placed below [trailingWidget].
  final String? description;

  /// The [Widget] placed after the [trailingWidget].
  final Widget actionWidget;

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// The `width` of the [Widget], by default it will be 500.
  final double? width;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  /// The [MainAxisAlignment] which defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [MainAxisSize] which defaults to [MainAxisSize.max].
  final MainAxisSize mainAxisSize;

  /// The [CrossAxisAlignment] which defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// The optional [TextDirection].
  final TextDirection? textDirection;

  /// The [VerticalDirection] which defaults to [VerticalDirection.down].
  final VerticalDirection verticalDirection;

  /// The optional [TextBaseline].
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: enabled
            ? Theme.of(context).textTheme.bodyLarge!.color
            : Theme.of(context).disabledColor,
      ),
      child: SizedBox(
        width: width,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: [
              if (leadingWidget != null) ...[
                leadingWidget!,
                const SizedBox(width: 8)
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    trailingWidget,
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          description!,
                          style: enabled
                              ? Theme.of(context).textTheme.bodySmall
                              : Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
              actionWidget,
            ],
          ),
        ),
      ),
    );
  }
}
