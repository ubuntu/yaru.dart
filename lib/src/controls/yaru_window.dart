import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'yaru_window_state.dart';

class YaruWindow {
  @visibleForTesting
  static WindowManager wm = WindowManager.instance;

  static Future<void> close(_) => wm.close();
  static Future<void> drag(_) => wm.startDragging();
  static Future<void> maximize(_) => wm.maximize();
  static Future<void> minimize(_) => wm.minimize();
  static Future<void> restore(_) => wm.unmaximize();
  static Future<void> showMenu(_) => wm.popUpWindowMenu();
  static Future<YaruWindowState> state() => wm.state();
  static Stream<YaruWindowState> states() async* {
    final listener = YaruWindowListener(wm);
    try {
      yield* listener.listen();
    } finally {
      await listener.close();
    }
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
  Future<YaruWindowState> state() {
    return Future.wait([
      isFocused().catchError((_) => true),
      isClosable().catchError((_) => true),
      isFullScreen().catchError((_) => false),
      isMaximizable().catchError((_) => true),
      isMaximized().catchError((_) => false),
      isMinimizable().catchError((_) => true),
      isMinimized().catchError((_) => false),
      isMovable().catchError((_) => true),
      getTitle().catchError((_) => ''),
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
        active: active,
        closable: closable,
        fullscreen: fullscreen,
        maximizable: maximizable && !maximized,
        maximized: maximized,
        minimizable: minimizable && !minimized,
        minimized: minimized,
        movable: movable,
        restorable: fullscreen || maximized || minimized,
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
