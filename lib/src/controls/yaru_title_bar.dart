import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_title_bar_theme.dart';
import 'yaru_window.dart';
import 'yaru_window_control.dart';

const _kTitleButtonPadding = EdgeInsets.symmetric(horizontal: 7);

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
    this.centerTitle,
    this.titleSpacing,
    this.foregroundColor,
    this.backgroundColor,
    this.isActive,
    this.isClosable,
    this.isDraggable,
    this.isMaximizable,
    this.isMinimizable,
    this.isRestorable,
    this.onClose,
    this.onDrag,
    this.onMaximize,
    this.onMinimize,
    this.onRestore,
    this.onShowMenu,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// A widget to display after the [title] widget.
  final Widget? trailing;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double? titleSpacing;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// Whether the title bar visualized as active.
  final bool? isActive;

  /// Whether the title bar shows a close button.
  final bool? isClosable;

  /// Whether the title bar can be dragged.
  final bool? isDraggable;

  /// Whether the title bar shows a maximize button.
  final bool? isMaximizable;

  /// Whether the title bar shows a minimize button.
  final bool? isMinimizable;

  /// Whether the title bar shows a restore button.
  final bool? isRestorable;

  /// Called when the close button is pressed.
  final FutureOr<void> Function(BuildContext)? onClose;

  /// Called when the title bar is dragged to move the window.
  final FutureOr<void> Function(BuildContext)? onDrag;

  /// Called when the maximize button is pressed or the title bar is
  /// double-clicked while the window is not maximized.
  final FutureOr<void> Function(BuildContext)? onMaximize;

  /// Called when the minimize button is pressed.
  final FutureOr<void> Function(BuildContext)? onMinimize;

  /// Called when the restore button is pressed or the title bar is
  /// double-clicked while the window is maximized.
  final FutureOr<void> Function(BuildContext)? onRestore;

  /// Called when the secondary mouse button is pressed.
  final FutureOr<void> Function(BuildContext)? onShowMenu;

  @override
  Size get preferredSize => const Size(0, kYaruTitleBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = YaruTitleBarTheme.of(context);
    final light = Theme.of(context).brightness == Brightness.light;

    final states = <MaterialState>{
      if (isActive == true) MaterialState.focused,
    };
    final defaultBackgroundColor = MaterialStateProperty.resolveWith((states) {
      if (!states.contains(MaterialState.focused)) {
        return Colors.transparent;
      }
      return light ? kYaruTitleBarBgLight : kYaruTitleBarBgDark;
    });
    final backgroundColor =
        MaterialStateProperty.resolveAs(this.backgroundColor, states) ??
            theme.backgroundColor?.resolve(states) ??
            defaultBackgroundColor.resolve(states);
    final foregroundColor =
        MaterialStateProperty.resolveAs(this.foregroundColor, states) ??
            theme.foregroundColor?.resolve(states) ??
            Theme.of(context).colorScheme.onSurface;

    final titleTextStyle = Theme.of(context)
        .appBarTheme
        .titleTextStyle!
        .copyWith(
          color: foregroundColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        )
        .merge(theme.titleTextStyle);
    final shape = theme.shape ??
        Border(
          bottom: BorderSide(
            color: light
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.06),
          ),
        );

    // TODO: backdrop effect
    Widget? backdropEffect(Widget? child) {
      if (child == null) return null;
      return AnimatedOpacity(
        opacity: isActive == true ? 1 : 0.75,
        duration: const Duration(milliseconds: 100),
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: isDraggable == true ? (_) => onDrag?.call(context) : null,
      onDoubleTap: () => isMaximizable == true
          ? onMaximize?.call(context)
          : isRestorable == true
              ? onRestore?.call(context)
              : null,
      onSecondaryTap: onShowMenu != null ? () => onShowMenu!(context) : null,
      child: AppBar(
        elevation: theme.elevation,
        automaticallyImplyLeading: false,
        leading: backdropEffect(leading),
        title: backdropEffect(title),
        centerTitle: centerTitle ?? theme.centerTitle,
        titleSpacing: titleSpacing ?? theme.titleSpacing,
        toolbarHeight: kYaruTitleBarHeight,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
        shape: shape,
        actions: [
          Hero(
            tag: '$this',
            child: backdropEffect(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailing != null)
                    Padding(
                      padding: _kTitleButtonPadding,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: trailing,
                      ),
                    ),
                  const SizedBox(width: 3),
                  if (isMinimizable == true)
                    Padding(
                      padding: _kTitleButtonPadding,
                      child: YaruWindowControl(
                        type: YaruWindowControlType.minimize,
                        onTap: onMinimize != null
                            ? () => onMinimize!(context)
                            : null,
                      ),
                    ),
                  if (isRestorable == true)
                    Padding(
                      padding: _kTitleButtonPadding,
                      child: YaruWindowControl(
                        type: YaruWindowControlType.restore,
                        onTap: onRestore != null
                            ? () => onRestore!(context)
                            : null,
                      ),
                    ),
                  if (isMaximizable == true)
                    Padding(
                      padding: _kTitleButtonPadding,
                      child: YaruWindowControl(
                        type: YaruWindowControlType.maximize,
                        onTap: onMaximize != null
                            ? () => onMaximize!(context)
                            : null,
                      ),
                    ),
                  if (isClosable == true)
                    Padding(
                      padding: _kTitleButtonPadding,
                      child: YaruWindowControl(
                        type: YaruWindowControlType.close,
                        onTap: onClose != null ? () => onClose!(context) : null,
                      ),
                    ),
                  const SizedBox(width: 3),
                ],
              ),
            )!,
          ),
        ],
      ),
    );
  }
}

class YaruWindowTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  const YaruWindowTitleBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.centerTitle,
    this.titleSpacing,
    this.foregroundColor,
    this.backgroundColor,
    this.isActive,
    this.isClosable,
    this.isDraggable,
    this.isMaximizable,
    this.isMinimizable,
    this.isRestorable,
    this.isVisible = !kIsWeb,
    this.onClose = YaruWindow.close,
    this.onDrag = YaruWindow.drag,
    this.onMaximize = YaruWindow.maximize,
    this.onMinimize = YaruWindow.minimize,
    this.onRestore = YaruWindow.restore,
    this.onShowMenu = YaruWindow.showMenu,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// A widget to display after the [title] widget.
  final Widget? trailing;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double? titleSpacing;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// Whether the title bar visualized as active.
  final bool? isActive;

  /// Whether the title bar shows a close button.
  final bool? isClosable;

  /// Whether the title bar can be dragged to move the window.
  final bool? isDraggable;

  /// Whether the title bar shows a maximize button.
  final bool? isMaximizable;

  /// Whether the title bar shows a minimize button.
  final bool? isMinimizable;

  /// Whether the title bar shows a restore button.
  final bool? isRestorable;

  /// Whether the title bar is visible.
  final bool? isVisible;

  /// Called when the close button is pressed.
  final FutureOr<void> Function(BuildContext)? onClose;

  /// Called when the title bar is dragged to move the window.
  final FutureOr<void> Function(BuildContext)? onDrag;

  /// Called when the maximize button is pressed or the title bar is
  /// double-clicked while the window is not maximized.
  final FutureOr<void> Function(BuildContext)? onMaximize;

  /// Called when the minimize button is pressed.
  final FutureOr<void> Function(BuildContext)? onMinimize;

  /// Called when the restore button is pressed or the title bar is
  /// double-clicked while the window is maximized.
  final FutureOr<void> Function(BuildContext)? onRestore;

  /// Called when the secondary mouse button is pressed.
  final FutureOr<void> Function(BuildContext)? onShowMenu;

  @override
  Size get preferredSize => const Size(0, kIsWeb ? 0 : kYaruTitleBarHeight);

  static Future<void> ensureInitialized() => YaruWindow.ensureInitialized();

  @override
  Widget build(BuildContext context) {
    if (isVisible == false) return const SizedBox.shrink();
    return StreamBuilder<YaruWindowState>(
      stream: YaruWindow.states(),
      initialData: YaruWindowState(
        isActive: isActive,
        isClosable: isClosable,
        isMaximizable: isMaximizable,
        isMinimizable: isMinimizable,
        isRestorable: isRestorable,
      ),
      builder: (context, snapshot) {
        final window = snapshot.data;
        return YaruTitleBar(
          leading: leading,
          title: title ?? Text(window?.title ?? ''),
          trailing: trailing,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          backgroundColor: backgroundColor,
          isActive: isActive ?? window?.isActive,
          isClosable: isClosable ?? window?.isClosable,
          isDraggable: isDraggable ?? window?.isMovable,
          isMaximizable: isMaximizable ?? window?.isMaximizable,
          isMinimizable: isMinimizable ?? window?.isMinimizable,
          isRestorable: isRestorable ?? window?.isRestorable,
          onClose: onClose,
          onDrag: onDrag,
          onMaximize: onMaximize,
          onMinimize: onMinimize,
          onRestore: onRestore,
          onShowMenu: onShowMenu,
        );
      },
    );
  }
}

class YaruDialogTitleBar extends YaruWindowTitleBar {
  const YaruDialogTitleBar({
    super.key,
    super.leading,
    super.title,
    super.trailing,
    super.centerTitle,
    super.titleSpacing,
    super.foregroundColor,
    super.backgroundColor,
    super.isActive,
    super.isClosable = true,
    super.isDraggable,
    super.isMaximizable = false,
    super.isMinimizable = false,
    super.isRestorable = false,
    super.isVisible = true,
    super.onClose = YaruWindow.maybePop,
    super.onDrag = YaruWindow.drag,
    super.onMaximize = null,
    super.onMinimize = null,
    super.onRestore = null,
    super.onShowMenu = YaruWindow.showMenu,
  });
}
