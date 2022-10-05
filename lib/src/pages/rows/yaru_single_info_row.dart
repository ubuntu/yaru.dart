import 'package:flutter/material.dart';

import '../yaru_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    return YaruTile(
      enabled: true,
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
