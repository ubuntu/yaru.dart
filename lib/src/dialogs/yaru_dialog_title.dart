import 'package:flutter/material.dart';

import '../constants.dart';
import '../controls/yaru_close_button.dart';

/// A [Stack] of a [Widget] as [title] with a close button
/// which pops the top-most route off the navigator
/// that most tightly encloses the given context.
///
class YaruDialogTitle extends StatelessWidget {
  const YaruDialogTitle({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.centerTitle = true,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// A widget to display after the [title] widget.
  final Widget? trailing;

  /// Whether the title should be centered.
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: leading,
      automaticallyImplyLeading: false,
      title: title,
      centerTitle: centerTitle,
      toolbarHeight: kYaruDialogTitleHeight,
      backgroundColor: Colors.transparent,
      titleTextStyle: Theme.of(context).dialogTheme.titleTextStyle,
      actions: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.topRight,
            child: trailing ?? const YaruCloseButton(),
          ),
        ),
      ],
    );
  }
}
