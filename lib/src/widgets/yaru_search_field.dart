import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/constants.dart';
import 'package:yaru_widgets/src/widgets/yaru_icon_button.dart';

/// A [TextField] to with fully rounded corners,
/// ideally in a [YaruWindowTitleBar] or [YaruDialogTitleBar]
class YaruSearchField extends StatefulWidget {
  const YaruSearchField({
    super.key,
    this.text,
    this.onSubmitted,
    this.hintText,
    this.height = kYaruWindowTitleBarItemHeight,
    this.contentPadding = const EdgeInsets.only(
      bottom: 10,
      top: 10,
      right: 15,
      left: 15,
    ),
    this.autoFocus = true,
    this.onClear,
    this.onChanged,
  });

  /// Optional [String] forwarded to the internal [TextEditingController]
  final String? text;

  /// Optional [String] used inside the internal [InputDecoration]
  final String? hintText;

  /// The callback forwarded to the [TextField] used when the enter key is pressed
  final void Function(String? value)? onSubmitted;

  /// The callback forwarded to the [TextField] used when input changes
  final void Function(String)? onChanged;

  /// Optional callback used to clear the [TextField]. If provided an [IconButton] will use it
  /// as the suffix icon inside the [InputDecoration]
  final void Function()? onClear;

  /// The height of the [TextField] that defaults to [kYaruWindowTitleBarItemHeight]
  final double height;

  /// The padding for the [InputDecoration] that defaults to `EdgeInsets.only(bottom: 10,top: 10, right: 15, left: 15)`
  final EdgeInsets contentPadding;

  /// Defines if the [TextField] is autofocused on build
  final bool autoFocus;

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

    const suffixRadius = BorderRadius.only(
      topRight: Radius.circular(kYaruWindowTitleBarItemHeight),
      bottomRight: Radius.circular(
        kYaruWindowTitleBarItemHeight,
      ),
    );
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          _clear();
        }
      },
      child: SizedBox(
        height: widget.height,
        child: TextField(
          autofocus: widget.autoFocus,
          style: theme.textTheme.bodyMedium,
          strutStyle: const StrutStyle(
            leading: 0.2,
          ),
          textAlignVertical: TextAlignVertical.center,
          cursorWidth: 1,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
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
            suffixIcon: widget.onClear == null
                ? null
                : IconButton(
                    style: IconButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: suffixRadius,
                      ),
                    ),
                    onPressed: _clear,
                    icon: const ClipRRect(
                      borderRadius: suffixRadius,
                      child: Icon(
                        YaruIcons.edit_clear,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _clear() {
    widget.onClear?.call();
    _controller.clear();
  }
}

/// Combines [YaruSearchField] and [YaruSearchButton] in a [Stack]
class YaruSearchFieldTitle extends StatefulWidget {
  const YaruSearchFieldTitle({
    super.key,
    required this.searchActive,
    required this.title,
    this.width = 190,
    this.titlePadding = const EdgeInsets.only(left: 45.0),
    this.autoFocus = true,
    this.text,
    this.hintText,
    this.onSubmitted,
    this.onClear,
    this.onSearchActive,
    this.onChanged,
  });

  final bool searchActive;
  final Widget title;
  final double width;
  final EdgeInsets titlePadding;
  final bool autoFocus;
  final String? text;
  final String? hintText;
  final void Function(String? value)? onSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onClear;
  final void Function()? onSearchActive;

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
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (_searchActive)
            Center(
              child: SizedBox(
                height: kYaruWindowTitleBarItemHeight,
                child: YaruSearchField(
                  height: widget.width,
                  hintText: widget.hintText,
                  onClear: widget.onClear,
                  autoFocus: widget.autoFocus,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  contentPadding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                    right: 15,
                    left: 45,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: widget.titlePadding,
              child: widget.title,
            ),
          YaruSearchButton(
            searchActive: _searchActive,
            onPressed: () => setState(() => _searchActive = !_searchActive),
          ),
        ],
      ),
    );
  }
}

/// A pre-styled [YaruIconButton], ideally used in combination with [YaruSearchField]
class YaruSearchButton extends StatelessWidget {
  const YaruSearchButton({
    super.key,
    required this.searchActive,
    this.onPressed,
    this.size = kYaruWindowTitleBarItemHeight,
  });

  final bool searchActive;
  final void Function()? onPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      widthFactor: 1,
      child: SizedBox(
        height: kYaruWindowTitleBarItemHeight,
        width: kYaruWindowTitleBarItemHeight,
        child: YaruIconButton(
          isSelected: searchActive,
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
          onPressed: onPressed,
        ),
      ),
    );
  }
}
