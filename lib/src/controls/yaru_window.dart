import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class YaruWindow {
  static final Map<Object, YaruWindowInstance> _windows = {};

  static YaruWindowInstance of(BuildContext context) {
    const id = 0; // View.of(context).windowId;
    return _windows[id] ??= YaruWindowInstance._(id);
  }

  static Future<void> close(BuildContext context) {
    return YaruWindow.of(context).close();
  }

  static Future<void> drag(BuildContext context) {
    return YaruWindow.of(context).drag();
  }

  static Future<void> maximize(BuildContext context) {
    return YaruWindow.of(context).maximize();
  }

  static Future<void> minimize(BuildContext context) {
    return YaruWindow.of(context).minimize();
  }

  static Future<void> restore(BuildContext context) {
    return YaruWindow.of(context).restore();
  }

  static Future<void> showMenu(BuildContext context) {
    return YaruWindow.of(context).showMenu();
  }

  static YaruWindowState? state(BuildContext context) {
    return YaruWindow.of(context).state;
  }

  static Stream<YaruWindowState> states(BuildContext context) {
    return YaruWindow.of(context).states();
  }

  static Future<void> maybePop(BuildContext context) {
    return Navigator.maybePop(context);
  }

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      await windowManager.ensureInitialized();
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    }
  }
}

class YaruWindowInstance {
  YaruWindowInstance._(this._id);

  final Object _id; // ignore: unused_field
  final _listener = YaruWindowListener(wm);

  @visibleForTesting
  static WindowManager wm = WindowManager.instance;

  Future<void> close() => wm.close().catchError((_) {});
  Future<void> drag() => wm.startDragging().catchError((_) {});
  Future<void> maximize() => wm.maximize().catchError((_) {});
  Future<void> minimize() => wm.minimize().catchError((_) {});
  Future<void> restore() => wm.unmaximize().catchError((_) {});
  Future<void> showMenu() => wm.popUpWindowMenu().catchError((_) {});

  YaruWindowState? get state => _listener.state;
  Stream<YaruWindowState> states() => _listener.states();
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
  StreamController<YaruWindowState>? _controller;
  YaruWindowState? _state;

  YaruWindowState? get state => _state;

  Stream<YaruWindowState> states() async* {
    _controller ??= StreamController<YaruWindowState>.broadcast(
      onListen: () => _wm.addListener(this),
      onCancel: () => _wm.removeListener(this),
    );
    if (_state == null) {
      _state = await _wm.state();
      yield _state!;
    }
    yield* _controller!.stream;
  }

  Future<void> close() async => await _controller?.close();

  Future<void> _updateState() async {
    _state = await _wm.state();
    _controller?.add(_state!);
  }

  @override
  void onWindowBlur() => _updateState();
  @override
  void onWindowFocus() => _updateState();
  @override
  void onWindowEnterFullScreen() => _updateState();
  @override
  void onWindowLeaveFullScreen() => _updateState();
  @override
  void onWindowMaximize() => _updateState();
  @override
  void onWindowUnmaximize() => _updateState();
  @override
  void onWindowMinimize() => _updateState();
  @override
  void onWindowRestore() => _updateState();
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

  YaruWindowState copyWith({
    bool? isActive,
    bool? isClosable,
    bool? isFullscreen,
    bool? isMaximizable,
    bool? isMaximized,
    bool? isMinimizable,
    bool? isMinimized,
    bool? isMovable,
    bool? isRestorable,
    String? title,
  }) {
    return YaruWindowState(
      isActive: isActive ?? this.isActive,
      isClosable: isClosable ?? this.isClosable,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isMaximizable: isMaximizable ?? this.isMaximizable,
      isMaximized: isMaximized ?? this.isMaximized,
      isMinimizable: isMinimizable ?? this.isMinimizable,
      isMinimized: isMinimized ?? this.isMinimized,
      isMovable: isMovable ?? this.isMovable,
      isRestorable: isRestorable ?? this.isRestorable,
      title: title ?? this.title,
    );
  }

  YaruWindowState merge(YaruWindowState? other) {
    return copyWith(
      isActive: other?.isActive,
      isClosable: other?.isClosable,
      isFullscreen: other?.isFullscreen,
      isMaximizable: other?.isMaximizable,
      isMaximized: other?.isMaximized,
      isMinimizable: other?.isMinimizable,
      isMinimized: other?.isMinimized,
      isMovable: other?.isMovable,
      isRestorable: other?.isRestorable,
      title: other?.title,
    );
  }

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
