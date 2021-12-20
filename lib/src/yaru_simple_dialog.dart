import 'package:flutter/material.dart';

class YaruSimpleDialog extends StatelessWidget {
  /// Create a [SimpleDialog] with a close button
  const YaruSimpleDialog(
      {Key? key,
      required this.title,
      required this.closeIconData,
      required this.children,
      this.semanticLabel,
      this.alignment})
      : super(key: key);

  /// The title of the dialog, displayed in a large font at the top of the dialog.
  final String title;

  /// The icon used inside the close button
  final IconData closeIconData;

  /// The content of the dialog, displayed underneath the title.
  final List<Widget> children;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the dialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be inferred from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.dialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  /// How to align the [Dialog].
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      title: Stack(
        alignment: Alignment.centerRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 48, right: 48), // Avoid title overflow on close button
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => Navigator.pop(context),
              splashRadius: 24,
              icon: Icon(closeIconData))
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      children: children,
      semanticLabel: semanticLabel,
      alignment: alignment,
    );
  }
}
