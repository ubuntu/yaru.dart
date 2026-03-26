import 'package:flutter/material.dart';

class IconViewModel extends ChangeNotifier {
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
    if (!isMaxIconSize) {
      _iconSize += 8;
      notifyListeners();
    }
  }

  void decreaseIconSize() {
    if (!isMinIconSize) {
      _iconSize -= 8;
      notifyListeners();
    }
  }

  bool get isMinIconSize => _iconSize <= 16 ? true : false;
  bool get isMaxIconSize => _iconSize >= 128 ? true : false;

  bool _searchActive = false;
  bool get searchActive => _searchActive;

  void toggleSearch() {
    _searchActive = !_searchActive;

    if (!_searchActive) {
      _searchQuery = '';
    }

    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void onSearchChanged(String? value) {
    _searchQuery = value ?? '';

    notifyListeners();
  }
}
