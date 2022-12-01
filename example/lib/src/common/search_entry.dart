import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru_icons/yaru_icons.dart';

class SearchEntry extends StatelessWidget implements PreferredSizeWidget {
  const SearchEntry({
    super.key,
    required this.appBarHeight,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onEscape,
  });

  final double appBarHeight;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function() onEscape;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          onEscape();
          return;
        }
      },
      child: TextField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          prefixIcon: const Icon(
            YaruIcons.search,
            size: 24,
          ),
          prefixIconConstraints: BoxConstraints.expand(
            width: 40,
            height: appBarHeight,
          ),
          hintText: 'Search icons...',
        ),
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Size get preferredSize => Size(0, appBarHeight);
}
