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
    Key? key,
    this.leadingWidget,
    required this.trailingWidget,
    this.description,
    required this.actionWidget,
    this.width,
  }) : super(key: key);

  /// The [Widget] placed at the leading position.
  /// A widget to display before the [trailingWidget].
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leadingWidget;

  /// The [Widget] placed at trailing position.
  final Widget trailingWidget;

  /// The Description placed below [trailingWidget]
  final String? description;

  /// The [Widget] placed after the [trailingWidget]
  final Widget actionWidget;

  /// The `width` of the [Widget], by default it will be 500.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                ],
              ),
            ),
            actionWidget,
          ],
        ),
      ),
    );
  }
}
