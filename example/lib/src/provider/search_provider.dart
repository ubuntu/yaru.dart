import 'package:flutter/material.dart';

import '../common/icon_item.dart';
import '../icon_items.dart';

class SearchProvider extends ChangeNotifier {
  List<IconItem>? filteredIconItems;
  List<IconItem>? filteredAnimatedIconItems;
  List<IconItem>? filteredWidgetIconItems;

  final textEntryController = TextEditingController();
  final textEntryFocusNode = FocusNode();

  bool _search = false;
  bool get search => _search;

  @override
  void dispose() {
    textEntryController.dispose();
    textEntryFocusNode.dispose();

    super.dispose();
  }

  void _escape() {
    filteredIconItems = null;
    filteredAnimatedIconItems = null;
    filteredWidgetIconItems = null;
    textEntryController.clear();
    textEntryFocusNode.unfocus();
  }

  void toggleSearch() {
    _search = !_search;

    if (_search) {
      textEntryFocusNode.requestFocus();
    } else {
      _escape();
    }

    notifyListeners();
  }

  void onEscape() {
    _escape();
    _search = !_search;

    notifyListeners();
  }

  void onSearchChanged(String value) {
    if (value == '') {
      filteredIconItems = null;
      filteredAnimatedIconItems = null;
      filteredWidgetIconItems = null;
      textEntryController.clear();

      notifyListeners();
    }

    filteredIconItems = [];
    filteredIconItems!.addAll(
      iconItems.where((iconItem) {
        return iconItem.name.toLowerCase().contains(value.toLowerCase());
      }),
    );

    filteredAnimatedIconItems = [];
    filteredAnimatedIconItems!.addAll(
      animatedIconItems.where((animatedIconItem) {
        return animatedIconItem.name
            .toLowerCase()
            .contains(value.toLowerCase());
      }),
    );

    filteredWidgetIconItems = [];
    filteredWidgetIconItems!.addAll(
      widgetIconItems.where((widgetIconItem) {
        return widgetIconItem.name.toLowerCase().contains(value.toLowerCase());
      }),
    );

    notifyListeners();
  }
}
