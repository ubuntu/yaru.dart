import 'package:flutter/material.dart';

import 'yaru_row.dart';

class YaruSingleInfoRow extends StatelessWidget {
  /// Creates an info widget with infoLabel and infoValue.
  /// Useful when there is a need of copying an info from the app.
  /// `infoValue` value is placed inside a [SelectableText] so that the value can be copied.
  ///
  /// for example:
  /// ```dart
  ///     YaruSingleInfoRow(
  ///        infoLabel: "Info Label",
  ///        infoValue: "Info Value",
  ///      );
  /// ```
  const YaruSingleInfoRow({
    super.key,
    required this.infoLabel,
    required this.infoValue,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
  });

  /// Specifies the label for the information and is placed at the trailing position.
  final String infoLabel;

  /// The information that needs to be shown.
  /// This property is placed inside a [SelectableText] so that the value passed to the
  /// `infoValue` can be selected and will also allow to copy that value.
  ///
  /// Default color of the text will be [Theme.of(context).colorScheme.onSurface.withAlpha(150)].
  final String infoValue;

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
    return YaruRow(
      enabled: true,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      title: Text(infoLabel),
      trailing: Expanded(
        flex: 2,
        child: SelectableText(
          infoValue,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
