import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class YaruWindow {
  @visibleForTesting
  static WindowManager wm = WindowManager.instance;

  static Future<void> close(_) => wm.close().catchError((_) {});
  static Future<void> drag(_) => wm.startDragging().catchError((_) {});
  static Future<void> maximize(_) => wm.maximize().catchError((_) {});
  static Future<void> minimize(_) => wm.minimize().catchError((_) {});
  static Future<void> restore(_) => wm.unmaximize().catchError((_) {});
  static Future<void> showMenu(_) => wm.popUpWindowMenu().catchError((_) {});
  static Future<YaruWindowState> state() => wm.state();
  static Stream<YaruWindowState> states() async* {
    final listener = YaruWindowListener(wm);
    yield await wm.state();
    try {
      yield* listener.listen();
    } finally {
      await listener.close();
    }
  }

  static Future<void> maybePop(BuildContext context) {
    return Navigator.maybePop(context);
  }

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      await wm.ensureInitialized();
      await wm.setTitleBarStyle(TitleBarStyle.hidden);
    }
  }
}

extension YaruWindowManagerX on WindowManager {
  Future<T> _invokeGetter<T>(
    Future<T> Function() getter, {
    required T orElse,
  }) async {
    try {
      return await getter();
    } on MissingPluginException catch (_) {
      return orElse;
    }
  }

  Future<YaruWindowState> state() {
    return Future.wait([
      _invokeGetter(isFocused, orElse: true),
      _invokeGetter(isClosable, orElse: true),
      _invokeGetter(isFullScreen, orElse: false),
      _invokeGetter(isMaximizable, orElse: true),
      _invokeGetter(isMaximized, orElse: false),
      _invokeGetter(isMinimizable, orElse: true),
      _invokeGetter(isMinimized, orElse: false),
      _invokeGetter(isMovable, orElse: true),
      _invokeGetter(getTitle, orElse: ''),
    ]).then((values) {
      final active = values[0] as bool;
      final closable = values[1] as bool;
      final fullscreen = values[2] as bool;
      final maximizable = values[3] as bool;
      final maximized = values[4] as bool;
      final minimizable = values[5] as bool;
      final minimized = values[6] as bool;
      final movable = values[7] as bool;
      final title = values[8] as String;
      return YaruWindowState(
        isActive: active,
        isClosable: closable && !Platform.isMacOS,
        isFullscreen: fullscreen,
        isMaximizable: maximizable && !maximized && !Platform.isMacOS,
        isMaximized: maximized,
        isMinimizable: minimizable && !minimized && !Platform.isMacOS,
        isMinimized: minimized,
        isMovable: movable && !kIsWeb,
        isRestorable:
            (fullscreen || maximized || minimized) && !Platform.isMacOS,
        title: title,
      );
    });
  }
}

class YaruWindowListener implements WindowListener {
  YaruWindowListener(this._wm);

  final WindowManager _wm;
  final _controller = StreamController<YaruWindowState>();

  Stream<YaruWindowState> listen() {
    _wm.addListener(this);
    return _controller.stream;
  }

  Future<void> close() async {
    _wm.removeListener(this);
    await _controller.close();
  }

  Future<void> _emitState() async => _controller.add(await _wm.state());

  @override
  void onWindowBlur() => _emitState();
  @override
  void onWindowFocus() => _emitState();
  @override
  void onWindowEnterFullScreen() => _emitState();
  @override
  void onWindowLeaveFullScreen() => _emitState();
  @override
  void onWindowMaximize() => _emitState();
  @override
  void onWindowUnmaximize() => _emitState();
  @override
  void onWindowMinimize() => _emitState();
  @override
  void onWindowRestore() => _emitState();
  @override
  void onWindowClose() {}
  @override
  void onWindowResize() {}
  @override
  void onWindowResized() {}
  @override
  void onWindowMove() {}
  @override
  void onWindowMoved() {}
  @override
  void onWindowEvent(String eventName) {}
}

@immutable
class YaruWindowState {
  const YaruWindowState({
    this.isActive,
    this.isClosable,
    this.isFullscreen,
    this.isMaximizable,
    this.isMaximized,
    this.isMinimizable,
    this.isMinimized,
    this.isMovable,
    this.isRestorable,
    this.title,
  });

  final bool? isActive;
  final bool? isClosable;
  final bool? isFullscreen;
  final bool? isMaximizable;
  final bool? isMaximized;
  final bool? isMinimizable;
  final bool? isMinimized;
  final bool? isMovable;
  final bool? isRestorable;
  final String? title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruWindowState &&
        other.isActive == isActive &&
        other.isClosable == isClosable &&
        other.isFullscreen == isFullscreen &&
        other.isMaximizable == isMaximizable &&
        other.isMaximized == isMaximized &&
        other.isMinimizable == isMinimizable &&
        other.isMinimized == isMinimized &&
        other.isMovable == isMovable &&
        other.isRestorable == isRestorable &&
        other.title == title;
  }

  @override
  int get hashCode {
    return Object.hash(
      isActive,
      isClosable,
      isFullscreen,
      isMaximizable,
      isMaximized,
      isMinimizable,
      isMinimized,
      isMovable,
      isRestorable,
      title,
    );
  }

  @override
  String toString() {
    return 'YaruWindowState(isActive: $isActive, isClosable: $isClosable, isFullscreen: $isFullscreen, isMaximizable: $isMaximizable, isMaximized: $isMaximized, isMinimizable: $isMinimizable, isMinimized: $isMinimized, isMovable: $isMovable, isRestorable: $isRestorable, title: $title)';
  }
}
