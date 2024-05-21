import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/theme.dart';
import 'package:yaru_window/yaru_window.dart';

import 'yaru_title_bar_gesture_detector.dart';
import 'yaru_title_bar_theme.dart';
import 'yaru_window_control.dart';

const _kYaruTitleBarHeroTag = '<YaruTitleBar hero tag>';

/// A generic title bar widget.
///
/// See also:
///  * [YaruTitleBarTheme]
///  * [YaruWindowTitleBar]
///  * [YaruDialogTitleBar]
class YaruTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const YaruTitleBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle,
    this.titleSpacing,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.border,
    this.style,
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
    this.heroTag = _kYaruTitleBarHeroTag,
    this.platform,
    this.buttonPadding,
    this.buttonSpacing,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// Widgets to display after the [title] widget.
  final List<Widget>? actions;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double? titleSpacing;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// The shape.
  final ShapeBorder? shape;

  /// The border.
  final BorderSide? border;

  /// The style.
  final YaruTitleBarStyle? style;

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

  /// The tag to use for the [Hero] wrapping the window controls.
  ///
  /// By default, a unique tag is used to ensure that the window controls stay
  /// in place during page transitions. If set to `null`, no [Hero] will be used.
  final Object? heroTag;

  /// Platform style of this window control, see [YaruWindowControlPlatform].
  ///
  /// Set to null if you want to auto select the correct platform.
  /// When [Platform.isWindows] is true, [YaruWindowControlPlatform.windows] will be used,
  /// [YaruWindowControlPlatform.yaru] will be used in all the other cases.
  final YaruWindowControlPlatform? platform;

  /// Optional padding around all [YaruWindowControl] buttons
  /// Defaulting to `EdgeInsets.symmetic(horizontal: 10)`
  /// or `EdgeInsets.only(bottom: 17)` on windows
  final EdgeInsetsGeometry? buttonPadding;

  /// Optional spacing between the [YaruWindowControl] buttons
  /// Defaults to 14 or 0 if Windows
  final double? buttonSpacing;

  @override
  Size get preferredSize =>
      Size(0, style == YaruTitleBarStyle.hidden ? 0 : kYaruTitleBarHeight);

  @override
  Widget build(BuildContext context) {
    final titleBarTheme = YaruTitleBarTheme.of(context);
    final style = this.style ?? titleBarTheme.style ?? YaruTitleBarStyle.normal;
    if (style == YaruTitleBarStyle.hidden) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final light = theme.colorScheme.isLight;
    final highContrast = theme.colorScheme.isHighContrast;
    final states = <WidgetState>{
      if (isActive != false) WidgetState.focused,
    };
    final defaultBackgroundColor = WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.focused)) {
        return theme.colorScheme.surface;
      }
      return light ? YaruColors.titleBarLight : YaruColors.titleBarDark;
    });
    final backgroundColor =
        WidgetStateProperty.resolveAs(this.backgroundColor, states) ??
            titleBarTheme.backgroundColor?.resolve(states) ??
            defaultBackgroundColor.resolve(states);
    final foregroundColor =
        WidgetStateProperty.resolveAs(this.foregroundColor, states) ??
            titleBarTheme.foregroundColor?.resolve(states) ??
            theme.colorScheme.onSurface;

    final titleTextStyle =
        (theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge!)
            .copyWith(
              color: foregroundColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
            .merge(titleBarTheme.titleTextStyle);

    final defaultBorder = BorderSide(
      strokeAlign: -1,
      color: light
          ? Colors.black.withOpacity(highContrast ? 1 : 0.1)
          : Colors.white.withOpacity(highContrast ? 1 : 0.06),
    );
    final border =
        Border(bottom: this.border ?? titleBarTheme.border ?? defaultBorder);
    final shape =
        border + (this.shape ?? titleBarTheme.shape ?? const Border());

    final bSpacing = buttonSpacing ??
        titleBarTheme.buttonSpacing ??
        (!kIsWeb && Platform.isWindows ? 0 : 14);
    final bPadding = buttonPadding ??
        titleBarTheme.buttonPadding ??
        (!kIsWeb && Platform.isWindows
            ? const EdgeInsets.only(bottom: 18)
            : const EdgeInsets.symmetric(horizontal: 10));
    final windowControlPlatform = platform ??
        (!kIsWeb && Platform.isWindows
            ? YaruWindowControlPlatform.windows
            : YaruWindowControlPlatform.yaru);

    Widget? backdropEffect(Widget? child) {
      if (child == null) return null;
      return AnimatedOpacity(
        opacity: isActive == true ? 1 : 0.75,
        duration: const Duration(milliseconds: 100),
        child: child,
      );
    }

    Widget maybeHero({
      required Widget child,
    }) {
      if (heroTag == null ||
          context.findAncestorWidgetOfExactType<Hero>() != null) {
        return child;
      }
      return Hero(
        tag: heroTag!,
        child: child,
      );
    }

    final closeButton = YaruWindowControl(
      platform: windowControlPlatform,
      iconColor: WidgetStatePropertyAll(foregroundColor),
      type: YaruWindowControlType.close,
      onTap: onClose != null ? () => onClose!(context) : null,
    );
    return TextFieldTapRegion(
      child: YaruTitleBarGestureDetector(
        onDrag: isDraggable == true ? (_) => onDrag?.call(context) : null,
        onDoubleTap: () => isMaximizable == true
            ? onMaximize?.call(context)
            : isRestorable == true
                ? onRestore?.call(context)
                : null,
        onSecondaryTap: onShowMenu != null ? () => onShowMenu!(context) : null,
        child: AppBar(
          elevation: titleBarTheme.elevation,
          automaticallyImplyLeading: false,
          leading: backdropEffect(leading),
          title: backdropEffect(title),
          centerTitle: centerTitle ?? titleBarTheme.centerTitle,
          titleSpacing: titleSpacing ?? titleBarTheme.titleSpacing,
          toolbarHeight: kYaruTitleBarHeight,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          titleTextStyle: titleTextStyle,
          shape: shape,
          actions: [
            maybeHero(
              child: backdropEffect(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...?actions,
                    if (style == YaruTitleBarStyle.normal &&
                        (isMinimizable == true ||
                            isRestorable == true ||
                            isMaximizable == true ||
                            isClosable == true))
                      Padding(
                        padding: bPadding,
                        child: Row(
                          children: [
                            if (isMinimizable == true)
                              YaruWindowControl(
                                platform: windowControlPlatform,
                                iconColor:
                                    WidgetStatePropertyAll(foregroundColor),
                                type: YaruWindowControlType.minimize,
                                onTap: onMinimize != null
                                    ? () => onMinimize!(context)
                                    : null,
                              ),
                            if (isRestorable == true)
                              YaruWindowControl(
                                platform: windowControlPlatform,
                                iconColor:
                                    WidgetStatePropertyAll(foregroundColor),
                                type: YaruWindowControlType.restore,
                                onTap: onRestore != null
                                    ? () => onRestore!(context)
                                    : null,
                              ),
                            if (isMaximizable == true)
                              YaruWindowControl(
                                platform: windowControlPlatform,
                                iconColor:
                                    WidgetStatePropertyAll(foregroundColor),
                                type: YaruWindowControlType.maximize,
                                onTap: onMaximize != null
                                    ? () => onMaximize!(context)
                                    : null,
                              ),
                            if (isClosable == true)
                              isMaximizable == true
                                  ? closeButton
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                      ),
                                      child: closeButton,
                                    ),
                          ].withSpacing(bSpacing),
                        ),
                      ),
                  ],
                ),
              )!,
            ),
          ],
        ),
      ),
    );
  }
}

extension _ListSpacing on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return expand((item) sync* {
      yield SizedBox(width: spacing);
      yield item;
    }).skip(1).toList();
  }
}

/// A window title bar.
///
/// `YaruWindowTitleBar` is a replacement for the native window title bar, that
/// allows inserting arbitrary Flutter widgets. It provides the same functionality
/// as the native window title bar, including window controls for minimizing,
/// maximizing, restoring, and closing the window, as well as a context menu,
/// and double-click-to-maximize and drag-to-move functionality.
///
/// ![](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/assets/yaru_window_title_bar.png)
///
/// ### Initialization
///
/// `YaruWindowTitleBar` must be initialized on application startup. This
/// ensures that the native window title bar is hidden and the window content
/// area is configured as appropriate for the underlying platform.
///
/// ```dart
/// Future<void> main() async {
///   await YaruWindowTitleBar.ensureInitialized();
///
///   runApp(...);
/// }
/// ```
///
/// ### Usage
///
/// `YaruWindowTitleBar` is typically used in place of `AppBar` in `Scaffold`.
///
/// ```dart
/// Scaffold(
///   appBar: const YaruWindowTitleBar(
///     title: Text('YaruWindowTitleBar'),
///   ),
///   body: ...
/// )
/// ```
///
/// ### Modal barrier
///
/// When `YaruWindowTitleBar` is placed inside a page route, it is not possible
/// to interact with the window title bar while a modal dialog is open because
/// the modal barrier is placed on top of the window title bar.
///
/// The issue can be avoided either by using [YaruDialogTitleBar] that allows
/// dragging the window from the dialog title bar, or by using [MaterialApp.builder](https://api.flutter.dev/flutter/material/MaterialApp/builder.html)
/// to place the window title bar outside of the page route.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => Scaffold(
///     appBar: const YaruWindowTitleBar(
///       title: Text('YaruWindowTitleBar'),
///     ),
///     body: child,
///   ),
///   home: ...
/// )
/// ```
///
/// | Home | Builder |
/// |---|---|
/// | ![](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/assets/yaru_window_title_bar-home.png) | ![](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/assets/yaru_window_title_bar-builder.png) |
///
/// ### Debug banner
///
/// The [debug banner](https://api.flutter.dev/flutter/material/MaterialApp/debugShowCheckedModeBanner.html)
/// shown by `MaterialApp` by default in debug mode does not fit well with an
/// in-scene window title bar. Therefore, when using `YaruWindowTitleBar`, it is
/// recommended to turn off the built-in debug banner by setting `debugShowCheckedModeBanner`
/// to `false` in `MaterialApp`. Optionally, [`CheckedModeBanner`](https://api.flutter.dev/flutter/widgets/CheckedModeBanner-class.html)
/// can be used to display the same debug banner in the content area instead so
/// that it does not overlap with the window title bar.
///
/// ```dart
/// MaterialApp(
///   debugShowCheckedModeBanner: false,
///   home: Scaffold(
///     appBar: YaruWindowTitleBar(),
///     body: CheckedModeBanner(
///       child: ...
///     ),
///   ),
/// )
/// ```
///
/// | `MaterialApp` | `CheckedModeBanner` |
/// |---|---|
/// | ![](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/assets/yaru_window_title_bar-debug.png) | ![](https://raw.githubusercontent.com/ubuntu/yaru.dart/main/doc/assets/yaru_window_title_bar-banner.png) |
class YaruWindowTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  const YaruWindowTitleBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle,
    this.titleSpacing,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.border,
    this.style,
    this.isActive,
    this.isClosable,
    this.isDraggable,
    this.isMaximizable,
    this.isMinimizable,
    this.isRestorable,
    this.onClose = YaruWindow.close,
    this.onDrag = YaruWindow.drag,
    this.onMaximize = YaruWindow.maximize,
    this.onMinimize = YaruWindow.minimize,
    this.onRestore = YaruWindow.restore,
    this.onShowMenu = YaruWindow.showMenu,
    this.heroTag = _kYaruTitleBarHeroTag,
    this.platform,
    this.buttonPadding,
    this.buttonSpacing,
  });

  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// Widgets to display after the [title] widget.
  final List<Widget>? actions;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double? titleSpacing;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  /// The shape.
  final ShapeBorder? shape;

  /// The border.
  final BorderSide? border;

  /// The style.
  final YaruTitleBarStyle? style;

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

  /// The tag to use for the [Hero] wrapping the window controls.
  ///
  /// By default, a unique tag is used to ensure that the window controls stay
  /// in place during page transitions. If set to `null`, no [Hero] will be used.
  final Object? heroTag;

  final YaruWindowControlPlatform? platform;

  final EdgeInsetsGeometry? buttonPadding;

  final double? buttonSpacing;

  @override
  Size get preferredSize =>
      Size(0, style == YaruTitleBarStyle.hidden ? 0 : kYaruTitleBarHeight);

  static Future<void> ensureInitialized() {
    _windowStates.clear();
    return YaruWindow.ensureInitialized().then((window) => window.hideTitle());
  }

  static final _windowStates = <YaruWindowInstance, YaruWindowState>{};

  @override
  Widget build(BuildContext context) {
    final theme = YaruTitleBarTheme.of(context);
    final style = this.style ??
        theme.style ??
        (kIsWeb ? YaruTitleBarStyle.undecorated : YaruTitleBarStyle.normal);
    if (style == YaruTitleBarStyle.hidden) return const SizedBox.shrink();

    final window = YaruWindow.of(context);
    return StreamBuilder<YaruWindowState>(
      stream: window.states(),
      initialData: _windowStates[window],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _windowStates[window] = snapshot.data!;
        }
        final state = snapshot.data;
        return YaruTitleBar(
          platform: platform,
          buttonPadding: buttonPadding,
          buttonSpacing: buttonSpacing,
          leading: leading,
          title: title ?? Text(state?.title ?? ''),
          actions: actions,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: shape,
          border: border,
          style: style,
          isActive: isActive ?? state?.isActive,
          isClosable: isClosable ?? state?.isClosable?.exceptMacOS(context),
          isDraggable: isDraggable ?? state?.isMovable,
          isMaximizable:
              isMaximizable ?? state?.isMaximizable?.exceptMacOS(context),
          isMinimizable:
              isMinimizable ?? state?.isMinimizable?.exceptMacOS(context),
          isRestorable:
              isRestorable ?? state?.isRestorable?.exceptMacOS(context),
          onClose: onClose,
          onDrag: onDrag,
          onMaximize: onMaximize,
          onMinimize: onMinimize,
          onRestore: onRestore,
          onShowMenu: onShowMenu,
          heroTag: heroTag,
        );
      },
    );
  }
}

/// A dialog title bar.
///
/// `YaruDialogTitleBar` makes Flutter dialogs feel as close as possible to top-
/// level windows. Dragging the dialog title bar moves the parent window, and it
/// is also possible to access the window context menu as if it was a real top-
/// level window.
class YaruDialogTitleBar extends YaruWindowTitleBar {
  const YaruDialogTitleBar({
    super.key,
    super.leading,
    super.title,
    super.actions,
    super.centerTitle,
    super.titleSpacing,
    super.foregroundColor,
    super.backgroundColor,
    super.shape = defaultShape,
    super.border,
    super.style = YaruTitleBarStyle.normal,
    super.isActive,
    super.isClosable = true,
    super.isDraggable,
    super.isMaximizable = false,
    super.isMinimizable = false,
    super.isRestorable = false,
    super.onClose = _maybePop,
    super.onDrag = YaruWindow.drag,
    super.onMaximize = null,
    super.onMinimize = null,
    super.onRestore = null,
    super.onShowMenu = YaruWindow.showMenu,
    super.heroTag = _kYaruTitleBarHeroTag,
    super.platform,
    super.buttonPadding,
    super.buttonSpacing,
  });

  static const defaultShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(kYaruContainerRadius),
    ),
  );

  static Future<void> _maybePop(BuildContext context) {
    return Navigator.maybePop(context);
  }
}

extension on bool? {
  bool? exceptMacOS(BuildContext context) {
    final platform = Theme.of(context).platform;
    return !kIsWeb && platform == TargetPlatform.macOS ? false : this;
  }
}
