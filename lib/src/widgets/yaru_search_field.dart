import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/constants.dart';
import 'package:yaru_widgets/src/widgets/yaru_icon_button.dart';

class YaruSearchField extends StatefulWidget {
  const YaruSearchField({
    super.key,
    this.text,
    this.onSubmitted,
    this.hintText,
    this.onSearchActive,
    this.height = kYaruWindowTitleBarItemHeight,
    this.contentPadding =
        const EdgeInsets.only(bottom: 10, top: 10, right: 15, left: 45),
  });

  final String? text;
  final String? hintText;
  final void Function(String? value)? onSubmitted;
  final void Function()? onSearchActive;
  final double height;
  final EdgeInsets contentPadding;

  @override
  State<YaruSearchField> createState() => _YaruSearchFieldState();
}

class _YaruSearchFieldState extends State<YaruSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusNode = FocusNode();

    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(100),
    );

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          widget.onSearchActive?.call();
        }
      },
      child: SizedBox(
        height: widget.height,
        child: TextField(
          autofocus: true,
          style: theme.textTheme.bodyMedium,
          strutStyle: const StrutStyle(
            leading: 0.2,
          ),
          textAlignVertical: TextAlignVertical.center,
          cursorWidth: 1,
          onSubmitted: widget.onSubmitted,
          controller: _controller,
          decoration: InputDecoration(
            border: border,
            enabledBorder: border,
            errorBorder: border,
            focusedBorder: border,
            contentPadding: widget.contentPadding,
            hintText: widget.hintText,
            fillColor: theme.dividerColor,
            hoverColor: theme.dividerColor.scale(lightness: 0.1),
          ),
        ),
      ),
    );
  }
}

class YaruSearchFieldTitle extends StatefulWidget {
  const YaruSearchFieldTitle({
    super.key,
    required this.searchActive,
    required this.title,
    this.width = 190,
    this.titlePadding = const EdgeInsets.only(left: 45.0),
  });

  final bool searchActive;
  final Widget title;
  final double width;
  final EdgeInsets titlePadding;

  @override
  State<YaruSearchFieldTitle> createState() => _YaruSearchFieldTitleState();
}

class _YaruSearchFieldTitleState extends State<YaruSearchFieldTitle> {
  late bool _searchActive;

  @override
  void initState() {
    super.initState();
    _searchActive = widget.searchActive;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (_searchActive)
            const Center(
              child: SizedBox(
                height: kYaruWindowTitleBarItemHeight,
                child: YaruSearchField(),
              ),
            )
          else
            Padding(
              padding: widget.titlePadding,
              child: widget.title,
            ),
          SizedBox(
            height: kYaruWindowTitleBarItemHeight,
            width: kYaruWindowTitleBarItemHeight,
            child: YaruIconButton(
              isSelected: _searchActive,
              selectedIcon: Icon(
                YaruIcons.search,
                size: kYaruIconSize,
                color: theme.colorScheme.onSurface,
              ),
              icon: Icon(
                YaruIcons.search,
                size: kYaruIconSize,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () => setState(() => _searchActive = !_searchActive),
            ),
          ),
        ],
      ),
    );
  }
}
