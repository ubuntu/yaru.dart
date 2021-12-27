import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YaruSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a search bar inside an [AppBar].
  ///
  /// By default the text style will be,
  /// ```dart
  ///   const TextStyle(fontSize: 18, fontWeight: FontWeight.w200)
  /// ```
  ///
  /// Vertical alignment of the [TextField] will be center.
  const YaruSearchAppBar({
    Key? key,
    required this.searchController,
    required this.onChanged,
    required this.onEscape,
    required this.searchIconData,
    required this.appBarHeight,
    required this.searchHint,
  }) : super(key: key);

  /// Pass a new [TextEditingController] instance.
  final TextEditingController searchController;

  /// The callback that gets invoked when the value changes in the text field.
  final Function(String value) onChanged;

  /// The callback that gets invoked when `escape` key is pressed.
  final Function() onEscape;

  /// Search icon for search bar.
  final IconData searchIconData;

  /// The height of the [AppBar].
  final double appBarHeight;

  /// Specifies the search hint.
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: RawKeyboardListener(
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            onEscape();
            return;
          }
        },
        focusNode: FocusNode(),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 28, right: 25),
              child: Icon(searchIconData),
            ),
            hintText: searchHint,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.01))),
            border: const UnderlineInputBorder(),
          ),
          controller: searchController,
          autofocus: true,
          onChanged: (value) => onChanged(value),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(0, appBarHeight);
}
