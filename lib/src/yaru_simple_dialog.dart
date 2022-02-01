import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';
import 'package:yaru_widgets/src/yaru_dialog_title.dart';

class YaruSimpleDialog extends StatelessWidget {
  /// Create a [SimpleDialog] with a close button
  const YaruSimpleDialog({
    Key? key,
    required this.title,
    required this.closeIconData,
    required this.children,
    this.semanticLabel,
    this.alignment,
    required this.width,
    this.titleTextAlign = TextAlign.center,
  }) : super(key: key);

  /// The title of the dialog, displayed in a large font at the top of the [YaruDialogTitle].
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

  /// How to align the [Dialog] on the Screen.
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  final AlignmentGeometry? alignment;

  /// The width of the dialog which must be provided and constraints all children with the same width.
  ///
  final double width;

  /// Optional [TextAlign] used for the [YaruDialogTitle]
  final TextAlign? titleTextAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SimpleDialog(
        titlePadding: const EdgeInsets.all(kDefaultDialogTitlePadding),
        title: YaruDialogTitle(
          title: title,
          closeIconData: closeIconData,
          textAlign: titleTextAlign,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        contentPadding: const EdgeInsets.fromLTRB(kDefaultPagePadding,
            kDefaultPagePadding, kDefaultPagePadding, kDefaultPagePadding),
        children: [
          for (var child in children) SizedBox(child: child, width: width)
        ],
        semanticLabel: semanticLabel,
        alignment: alignment,
      ),
    );
  }
}
