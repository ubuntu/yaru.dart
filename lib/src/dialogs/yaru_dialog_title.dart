import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../yaru_widgets.dart';

/// A [Stack] of a [Text] with given [title] and an [IconButton]
/// which pops the top-most route off the navigator
/// that most tightly encloses the given context.
///
class YaruDialogTitle extends StatelessWidget {
  const YaruDialogTitle({
    super.key,
    this.title,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    required this.isCloseable,
    this.titleAlignment = Alignment.center,
  });

  /// The [Widget] used for the title
  final Widget? title;

  /// The alignment of the [title]
  final AlignmentGeometry titleAlignment;

  /// The optional [MainAxisAlignment] used for the title [Row],
  /// which defaults to [MainAxisAlignment.start]
  final MainAxisAlignment? mainAxisAlignment;

  /// The optional [CrossAxisAlignment] used for the title [Row],
  /// which defaults to [CrossAxisAlignment.center]
  final CrossAxisAlignment? crossAxisAlignment;

  /// Must provide if this dialog is closeable or not
  final bool isCloseable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: kYaruPagePadding + 5, // Avoid title overflow on close button
            right: kYaruPagePadding, // Avoid title overflow on close button
            top: kYaruPagePadding,
            bottom: kYaruPagePadding,
          ),
          child: Align(alignment: titleAlignment, child: title),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: YaruIconButton(
            style: IconButton.styleFrom(
              fixedSize: const Size.square(34),
            ),
            onPressed: isCloseable ? () => Navigator.maybePop(context) : null,
            icon: const Icon(YaruIcons.window_close),
          ),
        )
      ],
    );
  }
}
