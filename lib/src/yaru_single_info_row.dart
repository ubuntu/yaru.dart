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
    Key? key,
    required this.infoLabel,
    required this.infoValue,
    this.width,
  }) : super(key: key);

  /// Specifies the label for the information and is placed at the trailing position.
  final String infoLabel;

  /// The information that needs to be shown.
  /// This property is placed inside a [SelectableText] so that the value passed to the
  /// `infoValue` can be selected and will also allow to copy that value.
  ///
  /// Default color of the text will be [Theme.of(context).colorScheme.onSurface.withAlpha(150)].
  final String infoValue;

  /// Optional width passed to [YaruRow]
  final double? width;

  @override
  Widget build(BuildContext context) {
    return YaruRow(
      width: width,
      enabled: true,
      trailingWidget: Text(infoLabel),
      actionWidget: Expanded(
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
