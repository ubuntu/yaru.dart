import 'dart:async';

import 'package:flutter/widgets.dart';

import 'yaru_window.dart';
import 'yaru_window_state.dart';

class YaruWindowController extends ChangeNotifier {
  YaruWindowController({
    YaruWindowState? state,
    this.close = YaruWindow.close,
    this.drag = YaruWindow.drag,
    this.maximize = YaruWindow.maximize,
    this.minimize = YaruWindow.minimize,
    this.restore = YaruWindow.restore,
    this.showMenu = YaruWindow.showMenu,
  }) : _state = state;

  final Future<void> Function(BuildContext)? close;
  final Future<void> Function(BuildContext)? drag;
  final Future<void> Function(BuildContext)? maximize;
  final Future<void> Function(BuildContext)? minimize;
  final Future<void> Function(BuildContext)? restore;
  final Future<void> Function(BuildContext)? showMenu;

  StreamSubscription<YaruWindowState>? _listener;

  Future<void> init() async {
    _listener ??= YaruWindow.states().listen(_setWindowState);
    _setWindowState(await YaruWindow.state());
  }

  @override
  Future<void> dispose() async {
    await _listener?.cancel();
    _listener = null;
    super.dispose();
  }

  YaruWindowState? get state => _windowState.merge(_state);
  YaruWindowState? _state;
  set state(YaruWindowState? state) {
    if (_state == state) return;
    _state = state;
    notifyListeners();
  }

  var _windowState = const YaruWindowState();
  void _setWindowState(YaruWindowState state) {
    if (_windowState == state) return;
    _windowState = state;
    notifyListeners();
  }
}
