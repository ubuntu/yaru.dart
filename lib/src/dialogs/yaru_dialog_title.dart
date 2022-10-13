import 'package:flutter/material.dart';

import '../../yaru_widgets.dart';

/// A [Stack] of a [Widget] as [title] with a close button
/// which pops the top-most route off the navigator
/// that most tightly encloses the given context.
///
class YaruDialogTitle extends StatelessWidget {
  const YaruDialogTitle({
    super.key,
    this.title,
    required this.isCloseable,
    this.titleAlignment = Alignment.center,
  });

  /// The [Widget] used for the title
  final Widget? title;

  /// The alignment of the [title]
  final AlignmentGeometry titleAlignment;

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
          child: YaruCloseButton(enabled: isCloseable),
        )
      ],
    );
  }
}
