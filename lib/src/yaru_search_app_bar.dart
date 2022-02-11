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
    required this.automaticallyImplyLeading,
    this.searchIconData,
    required this.appBarHeight,
    this.textStyle,
    this.searchHint,
  }) : super(key: key);

  /// Pass a new [TextEditingController] instance.
  final TextEditingController searchController;

  /// The callback that gets invoked when the value changes in the text field.
  final Function(String value) onChanged;

  /// The callback that gets invoked when `escape` key is pressed.
  final Function() onEscape;

  /// Search icon for search bar.
  final IconData? searchIconData;

  /// The height of the [AppBar].
  final double appBarHeight;

  /// Specifies the search hint.
  final String? searchHint;

  /// Specifies the [TextStyle]
  final TextStyle? textStyle;

  /// If false, hides the search icon in the [AppBar]
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.foregroundColor;
    return AppBar(
      toolbarHeight: appBarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: RawKeyboardListener(
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            onEscape();
            return;
          }
        },
        focusNode: FocusNode(),
        child: SizedBox(
          height: appBarHeight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextField(
              expands: true,
              maxLines: null,
              minLines: null,
              cursorColor: textColor,
              textAlignVertical: TextAlignVertical.center,
              style: textStyle ??
                  Theme.of(context)
                      .appBarTheme
                      .titleTextStyle
                      ?.copyWith(fontWeight: FontWeight.w200, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding:
                      const EdgeInsets.only(left: 28, right: 25, bottom: 7),
                  child: Icon(
                    searchIconData ?? Icons.search,
                    color: textColor,
                  ),
                ),
                hintText: searchHint,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.01))),
                border: const UnderlineInputBorder(),
              ),
              controller: searchController,
              autofocus: true,
              onChanged: (value) => onChanged(value),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(0, appBarHeight);
}
