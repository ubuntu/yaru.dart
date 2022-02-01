import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';
import 'package:yaru_widgets/src/yaru_dialog_title.dart';

class YaruAlertDialog extends StatelessWidget {
  const YaruAlertDialog({
    Key? key,
    required this.title,
    this.closeIconData,
    required this.children,
    this.alignment,
    required this.width,
    this.height,
    this.titleTextAlign,
    this.actions,
  }) : super(key: key);

  /// The title of the dialog, displayed in a large font at the top of the [YaruDialogTitle].
  final String title;

  /// The icon used inside the close button
  final IconData? closeIconData;

  /// The content of the dialog, displayed underneath the title.
  final List<Widget> children;

  /// How to align the [Dialog] on the Screen.
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  final AlignmentGeometry? alignment;

  /// The width of the dialog which must be provided and constraints all children with the same width.
  ///
  final double width;

  final double? height;

  /// Optional [TextAlign] used for the [YaruDialogTitle]
  final TextAlign? titleTextAlign;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AlertDialog(
        actionsPadding: const EdgeInsets.all(kDefaultPagePadding / 2),
        contentPadding: const EdgeInsets.fromLTRB(kDefaultPagePadding,
            kDefaultPagePadding / 2, kDefaultPagePadding, kDefaultPagePadding),
        titlePadding: const EdgeInsets.all(kDefaultDialogTitlePadding),
        title: YaruDialogTitle(
          mainAxisAlignment: MainAxisAlignment.start,
          textAlign: titleTextAlign,
          title: title,
          closeIconData: closeIconData ?? Icons.close,
        ),
        content: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var child in children) SizedBox(child: child, width: width)
              ],
            ),
          ),
        ),
        actions: actions,
        alignment: alignment,
      ),
    );
  }
}
