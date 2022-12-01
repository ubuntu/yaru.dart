import 'package:flutter/material.dart';

class IconViewProvider extends ChangeNotifier {
  bool _gridView = true;
  bool get gridView => _gridView;

  void toggleGridView() {
    _gridView = !_gridView;
    notifyListeners();
  }

  double _iconSize = 48;
  double get iconSize => _iconSize;

  set iconSize(double iconSize) {
    _iconSize = iconSize;
    notifyListeners();
  }

  void increaseIconSize() {
    if (!maxIconSize) {
      _iconSize += 8;
      notifyListeners();
    }
  }

  void decreaseIconSize() {
    if (!minIconSize) {
      _iconSize -= 8;
      notifyListeners();
    }
  }

  bool get minIconSize => _iconSize <= 16 ? true : false;
  bool get maxIconSize => _iconSize >= 128 ? true : false;
}
