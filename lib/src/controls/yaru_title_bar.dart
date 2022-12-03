import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_close_button.dart';

/// A [Stack] of a [Widget] as [title] with a close button
/// which pops the top-most route off the navigator
/// that most tightly encloses the given context.
///
class YaruTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const YaruTitleBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.centerTitle = true,
    this.backgroundColor = Colors.transparent,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// A widget to display after the [title] widget.
  final Widget? trailing;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// The background color. Defaults to [Colors.transparent].
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size(0, kYaruTitleBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: leading,
      automaticallyImplyLeading: false,
      title: title,
      centerTitle: centerTitle,
      toolbarHeight: kYaruTitleBarHeight,
      backgroundColor: backgroundColor,
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
