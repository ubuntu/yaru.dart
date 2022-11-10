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
  ConnectivityResult? _connectivityResult = ConnectivityResult.wifi;
  ConnectivityResult? get state => _connectivityResult;

  bool _compactMode = false;
  bool get compactMode => _compactMode;
  set compactMode(bool value) {
    if (value == _compactMode) return;
    _compactMode = value;
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

  bool get appIsOnline => _connectivityResult != ConnectivityResult.none;

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
