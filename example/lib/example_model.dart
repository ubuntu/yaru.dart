import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:yaru/yaru.dart';

class ExampleModel extends SafeChangeNotifier {
  ExampleModel(this._connectivity);

  final Connectivity _connectivity;
  StreamSubscription? _connectivitySub;
  List<ConnectivityResult> _connectivityResult = [ConnectivityResult.wifi];
  List<ConnectivityResult> get state => _connectivityResult;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode value) {
    if (value == _themeMode) return;
    _themeMode = value;
    notifyListeners();
  }

  bool _forceHighContrast = false;
  bool get forceHighContrast => _forceHighContrast;
  void toggleForceHighContrast() {
    _forceHighContrast = !_forceHighContrast;
    notifyListeners();
  }

  YaruVariant? _yaruVariant;
  YaruVariant? get yaruVariant => _yaruVariant;
  void setYaruVariant(YaruVariant value) {
    if (value == _yaruVariant) return;
    _yaruVariant = value;
    notifyListeners();
  }

  bool _compactMode = false;
  bool get compactMode => _compactMode;
  set compactMode(bool value) {
    if (value == _compactMode) return;
    _compactMode = value;
    notifyListeners();
  }

  bool _rtl = false;
  bool get rtl => _rtl;
  set rtl(bool value) {
    if (value == _rtl) return;
    _rtl = value;
    notifyListeners();
  }

  Future<void> init() async => initConnectivity();

  @override
  void dispose() {
    _connectivitySub?.cancel();

    super.dispose();
  }

  Future<void> refreshConnectivity() {
    return _connectivity.checkConnectivity().then((state) {
      _connectivityResult = state;
      notifyListeners();
    });
  }

  bool get appIsOnline =>
      _connectivityResult.contains(ConnectivityResult.wifi) ||
      _connectivityResult.contains(ConnectivityResult.ethernet) ||
      _connectivityResult.contains(ConnectivityResult.bluetooth) ||
      _connectivityResult.contains(ConnectivityResult.mobile) ||
      _connectivityResult.contains(ConnectivityResult.vpn);

  Future<void> initConnectivity() async {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((result) {
      _connectivityResult = result;

      notifyListeners();
    });
    return refreshConnectivity();
  }

  Future<String> getCodeSnippet(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    return response.body;
  }
}
