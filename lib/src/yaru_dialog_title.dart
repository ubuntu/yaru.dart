import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';

/// A [Stack] of a [Text] with given [title] and an [IconButton]
/// which pops the top-most route off the navigator
/// that most tightly encloses the given context.
///
class YaruDialogTitle extends StatelessWidget {
  const YaruDialogTitle({
    Key? key,
    this.title,
    this.closeIconData = Icons.close,
    this.textAlign,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.onPressed,
    this.titleWidget,
  }) : super(key: key);

  /// The [String] used for the title
  final String? title;

  /// An optional [Widget] displayed right to the [title]
  final Widget? titleWidget;

  /// The optional [IconData] used for the [IconButton]
  /// which defaults to [Icons.close]
  final IconData? closeIconData;

  /// The optional [TextAlign], defaults to [TextAlign.center]
  final TextAlign? textAlign;

  /// The optional [MainAxisAlignment] used for the title [Row],
  /// which defaults to [MainAxisAlignment.start]
  final MainAxisAlignment? mainAxisAlignment;

  /// The optional [CrossAxisAlignment] used for the title [Row],
  /// which defaults to [CrossAxisAlignment.center]
  final CrossAxisAlignment? crossAxisAlignment;

  /// The optional callback, defaults to pop the current route
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: kDefaultPagePadding +
                  5, // Avoid title overflow on close button
              right:
                  kDefaultPagePadding, // Avoid title overflow on close button
              top: kDefaultPagePadding,
              bottom: kDefaultPagePadding),
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: [
              Text(
                title ?? '',
                textAlign: textAlign,
              ),
              if (titleWidget != null)
                const SizedBox(
                  width: 10,
                ),
              if (titleWidget != null) titleWidget!
            ],
          ),
        ),
        IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPressed ?? () => Navigator.pop(context),
            splashRadius: 16,
            icon: Icon(closeIconData ?? Icons.close))
      ],
    );
  }
}
