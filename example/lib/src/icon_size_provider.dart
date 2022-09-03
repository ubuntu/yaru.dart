import 'package:flutter/material.dart';

class IconSizeProvider extends ChangeNotifier {
  double _size = 24;

  double get size => _size;

  set size(double size) {
    _size = size;
    notifyListeners();
  }

  void increaseSize() {
    _size += 8;
    notifyListeners();
  }

  void decreaseSize() {
    if (!isMinSize()) {
      _size -= 8;
    }
    notifyListeners();
  }

  bool isMinSize() => _size <= 16 ? true : false;
}
