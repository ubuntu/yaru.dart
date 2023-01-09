import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_title_bar_theme.dart';
import 'yaru_window.dart';
import 'yaru_window_control.dart';
import 'yaru_window_controller.dart';
import 'yaru_window_state.dart';

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
    this.foregroundColor,
    this.backgroundColor,
    this.isActive,
    this.isClosable,
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

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// Whether the title bar visualized as active.
  final bool? isActive;

  /// Whether the title bar shows a close button.
  final bool? isClosable;

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
      return Colors.black.withOpacity(light ? 0.075 : 0.2);
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
            color: Colors.black.withOpacity(light ? 0.1 : 0.2),
          ),
        );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => onDrag?.call(context),
      onDoubleTap: () => isMaximizable == true
          ? onMaximize?.call(context)
          : isRestorable == true
              ? onRestore?.call(context)
              : null,
      onSecondaryTap: onShowMenu != null ? () => onShowMenu!(context) : null,
      child: AnimatedOpacity(
        // TODO: backdrop effect
        opacity: isActive == true ? 1 : 0.75,
        duration: kThemeAnimationDuration,
        child: AppBar(
          elevation: theme.elevation,
          leading: leading,
          automaticallyImplyLeading: false,
          title: title,
          centerTitle: centerTitle ?? theme.centerTitle,
          toolbarHeight: kYaruTitleBarHeight,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          titleTextStyle: titleTextStyle,
          shape: shape,
          actions: [
            Hero(
              tag: '$this',
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}

class YaruWindowTitleBar extends StatefulWidget implements PreferredSizeWidget {
  const YaruWindowTitleBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.controller,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// A widget to display after the [title] widget.
  final Widget? trailing;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// An optional controller.
  final YaruWindowController? controller;

  @override
  Size get preferredSize => const Size(0, kIsWeb ? 0 : kYaruTitleBarHeight);

  @override
  State<YaruWindowTitleBar> createState() => _YaruWindowTitleBarState();

  static Future<void> ensureInitialized() => YaruWindow.ensureInitialized();
}

class _YaruWindowTitleBarState extends State<YaruWindowTitleBar> {
  late YaruWindowController _controller;

  YaruWindowController createController() {
    return YaruWindowController(
      state: kIsWeb
          ? const YaruWindowState(
              closable: false,
              movable: false,
              maximizable: false,
              minimizable: false,
            )
          : Platform.isMacOS
              ? const YaruWindowState(
                  closable: false,
                  maximizable: false,
                  minimizable: false,
                )
              : null,
    );
  }

  bool get isVisible => !kIsWeb;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? createController();
    _controller.init();
  }

  @override
  void didUpdateWidget(covariant YaruWindowTitleBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? createController();
      _controller.init();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => YaruTitleBar(
        leading: widget.leading,
        title: widget.title ?? Text(_controller.state?.title ?? ''),
        trailing: widget.trailing,
        centerTitle: widget.centerTitle,
        backgroundColor: widget.backgroundColor,
        isActive: _controller.state?.active,
        isClosable: _controller.state?.closable,
        isMaximizable: _controller.state?.maximizable,
        isMinimizable: _controller.state?.minimizable,
        isRestorable: _controller.state?.restorable,
        onClose: _controller.close,
        onDrag: _controller.state?.movable == true ? _controller.drag : null,
        onMaximize: _controller.maximize,
        onMinimize: _controller.minimize,
        onRestore: _controller.restore,
        onShowMenu: _controller.showMenu,
      ),
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
    super.backgroundColor,
    super.controller,
  });

  @override
  State<YaruWindowTitleBar> createState() => _YaruDialogTitleBarState();
}

class _YaruDialogTitleBarState extends _YaruWindowTitleBarState {
  @override
  YaruWindowController createController() {
    return YaruWindowController(
      state: const YaruWindowState(
        closable: true,
        maximizable: false,
        minimizable: false,
        movable: !kIsWeb,
        restorable: false,
      ),
      close: Navigator.of(context).maybePop,
    );
  }

  @override
  bool get isVisible => true;
}
