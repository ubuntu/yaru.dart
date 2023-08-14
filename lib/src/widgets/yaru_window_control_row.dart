import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../yaru_widgets.dart';

class YaruWindowControlRow extends StatelessWidget {
  const YaruWindowControlRow({
    super.key,
    required this.windowControls,
    required this.buttonPadding,
    required this.buttonSpacing,
    required this.isMaximized,
    required this.onClose,
    required this.onMaximize,
    required this.onMinimize,
    required this.onRestore,
    this.foregroundColor,
    this.backgroundColor,
  });

  final List<YaruWindowControlType> windowControls;
  final EdgeInsetsGeometry buttonPadding;
  final double buttonSpacing;
  final bool isMaximized;

  /// Called when the close button is pressed.
  final FutureOr<void> Function(BuildContext)? onClose;

  /// Called when the maximize button is pressed or the title bar is
  /// double-clicked while the window is not maximized.
  final FutureOr<void> Function(BuildContext)? onMaximize;

  /// Called when the minimize button is pressed.
  final FutureOr<void> Function(BuildContext)? onMinimize;

  /// Called when the restore button is pressed or the title bar is
  /// double-clicked while the window is maximized.
  final FutureOr<void> Function(BuildContext)? onRestore;

  /// The foreground color.
  final Color? foregroundColor;

  /// The background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: Row(
        children: windowControls
            .map((type) {
              switch (type) {
                case YaruWindowControlType.close:
                  return YaruWindowControl(
                    foregroundColor: foregroundColor,
                    backgroundColor: backgroundColor,
                    type: YaruWindowControlType.close,
                    onTap: onClose != null ? () => onClose!(context) : null,
                  );
                case YaruWindowControlType.maximize:
                case YaruWindowControlType.restore:
                  if (isMaximized == true) {
                    return YaruWindowControl(
                      foregroundColor: foregroundColor,
                      backgroundColor: backgroundColor,
                      type: YaruWindowControlType.restore,
                      onTap:
                          onRestore != null ? () => onRestore!(context) : null,
                    );
                  } else {
                    return YaruWindowControl(
                      foregroundColor: foregroundColor,
                      backgroundColor: backgroundColor,
                      type: YaruWindowControlType.maximize,
                      onTap: onMaximize != null
                          ? () => onMaximize!(context)
                          : null,
                    );
                  }
                case YaruWindowControlType.minimize:
                  return YaruWindowControl(
                    foregroundColor: foregroundColor,
                    backgroundColor: backgroundColor,
                    type: YaruWindowControlType.minimize,
                    onTap:
                        onMinimize != null ? () => onMinimize!(context) : null,
                  );
              }
            })
            .toList()
            .withSpacing(buttonSpacing),
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
