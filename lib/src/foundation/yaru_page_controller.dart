import 'package:flutter/material.dart';

class YaruPageController extends ChangeNotifier {
  YaruPageController({required this.length, this.initialIndex = -1})
      : _index = initialIndex,
        _previousIndex = initialIndex;
  final int length;
  final int initialIndex;

  int get index => _index;
  int _index;
  set index(int value) => _setIndex(value);

  int get previousIndex => _previousIndex;
  int _previousIndex;

  void _setIndex(value) {
    assert(value < length || length == 0);
    _previousIndex = _index;
    _index = value;
    notifyListeners();
  }
}
