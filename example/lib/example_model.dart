import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:safe_change_notifier/safe_change_notifier.dart';

class ExampleModel extends SafeChangeNotifier {
  ExampleModel(
    this._connectivity,
  );

  final Connectivity _connectivity;
  StreamSubscription? _connectivitySub;
  List<ConnectivityResult> _connectivityResult = [ConnectivityResult.wifi];
  List<ConnectivityResult> get state => _connectivityResult;

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

  Future<void> init() async {
    await initConnectivity();
  }

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
