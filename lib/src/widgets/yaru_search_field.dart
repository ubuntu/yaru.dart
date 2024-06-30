import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/src/widgets/yaru_icon_button.dart';
import 'package:yaru/theme.dart';

/// A [TextField] to with fully rounded corners,
/// ideally in a [YaruWindowTitleBar] or [YaruDialogTitleBar]
class YaruSearchField extends StatefulWidget {
  const YaruSearchField({
    super.key,
    this.text,
    this.onSubmitted,
    this.hintText,
    this.height = kYaruTitleBarItemHeight,
    this.contentPadding = const EdgeInsets.only(
      bottom: 10,
      top: 10,
      right: 15,
      left: 15,
    ),
    this.autofocus = true,
    this.onClear,
    this.onChanged,
    this.radius = const Radius.circular(kYaruTitleBarItemHeight),
    this.style = YaruSearchFieldStyle.filled,
    this.borderColor,
    this.fillColor,
    this.controller,
    this.focusNode,
    this.clearIcon,
  });

  /// Optional [String] forwarded to the internal [TextEditingController]
  final String? text;

  /// Optional [String] used inside the internal [InputDecoration]
  final String? hintText;

  /// The callback forwarded to the [TextField] used when the enter key is pressed
  final void Function(String? value)? onSubmitted;

  /// The callback forwarded to the [TextField] used when input changes
  final void Function(String value)? onChanged;

  /// Optional callback used to clear the [TextField]. If provided an [IconButton] will use it
  /// as the suffix icon inside the [InputDecoration]
  final void Function()? onClear;

  /// The height of the [TextField] that defaults to [kYaruTitleBarItemHeight]
  final double height;

  /// The padding for the [InputDecoration] that defaults to `EdgeInsets.only(bottom: 10,top: 10, right: 15, left: 15)`
  final EdgeInsets contentPadding;

  /// Defines if the [TextField] is autofocused on build
  final bool autofocus;

  /// Defines the radius for the corners.
  final Radius radius;

  final YaruSearchFieldStyle style;

  /// Optional [Color] for the border. If not provided
  /// it will fall back to `ColorScheme.dividerColor`.
  final Color? borderColor;

  /// Optional [Color] for the border. If not provided
  /// it will fall back to `ColorScheme.dividerColor`.
  final Color? fillColor;

  /// Optional controller for the internal [TextField]
  final TextEditingController? controller;

  /// Optional [FocusNode] for the internal [KeyboardListener]
  final FocusNode? focusNode;

  /// Optional icon shown inside the clear button.
  final Widget? clearIcon;

  @override
  State<YaruSearchField> createState() => _YaruSearchFieldState();
}

class _YaruSearchFieldState extends State<YaruSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.text);
    _focusNode = widget.focusNode ?? FocusNode();

    var isInputEmpty = _controller.text.isEmpty;
    _controller.addListener(() {
      if (isInputEmpty != _controller.text.isEmpty) {
        setState(() {
          isInputEmpty = _controller.text.isEmpty;
        });
      }
    });
  }

  @override
  void didUpdateWidget(YaruSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) _controller.dispose();
      _controller =
          widget.controller ?? TextEditingController(text: widget.text);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;

    final border = OutlineInputBorder(
      borderSide: widget.style == YaruSearchFieldStyle.filled
          ? BorderSide.none
          : BorderSide(
              color: widget.borderColor ??
                  theme.colorScheme.outline
                      .scale(lightness: light ? -0.1 : 0.1),
              width: 1,
            ),
      borderRadius: BorderRadius.all(widget.radius),
    );

    final suffixRadius = BorderRadius.only(
      topRight: widget.radius,
      bottomRight: widget.radius,
    );

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          _clear();
        }
      },
      child: SizedBox(
        height: widget.height,
        child: TextField(
          autofocus: widget.autofocus,
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
            filled: widget.style != YaruSearchFieldStyle.outlined,
            border: border,
            enabledBorder: border,
            errorBorder: border,
            focusedBorder: border,
            contentPadding: widget.contentPadding,
            hintText: widget.hintText,
            fillColor: widget.fillColor ?? theme.dividerColor,
            hoverColor:
                (widget.fillColor ?? theme.dividerColor).scale(lightness: 0.1),
            suffixIconConstraints:
                const BoxConstraints(maxWidth: kYaruTitleBarItemHeight),
            suffixIcon:
                widget.onClear == null || _controller.text.isEmpty == true
                    ? null
                    : IconButton(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: suffixRadius,
                          ),
                        ),
                        onPressed: _clear,
                        icon: ClipRRect(
                          borderRadius: suffixRadius,
                          child: widget.clearIcon ??
                              const Icon(
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

/// Combines [YaruSearchField], [YaruSearchButton] and any title [Widget] in a [Stack]
class YaruSearchTitleField extends StatefulWidget {
  const YaruSearchTitleField({
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
    this.alignment = Alignment.centerLeft,
    this.radius = const Radius.circular(kYaruTitleBarItemHeight),
    this.style = YaruSearchFieldStyle.filled,
    this.controller,
    this.focusNode,
    this.searchIcon,
    this.clearIcon,
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
  final Alignment alignment;
  final Radius radius;
  final YaruSearchFieldStyle style;

  /// Optional controller for the internal [TextField]
  final TextEditingController? controller;

  /// Optional [FocusNode] for the internal [KeyboardListener]
  final FocusNode? focusNode;

  final Widget? searchIcon;

  final Widget? clearIcon;

  @override
  State<YaruSearchTitleField> createState() => _YaruSearchTitleFieldState();
}

class _YaruSearchTitleFieldState extends State<YaruSearchTitleField> {
  late bool _searchActive;

  @override
  void initState() {
    super.initState();
    _searchActive = widget.searchActive;
  }

  @override
  void didUpdateWidget(covariant YaruSearchTitleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _searchActive = widget.searchActive;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.all(widget.radius),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (_searchActive)
              Center(
                child: SizedBox(
                  height: kYaruTitleBarItemHeight,
                  child: YaruSearchField(
                    clearIcon: widget.clearIcon,
                    focusNode: widget.focusNode,
                    controller: widget.controller,
                    text: widget.text,
                    style: widget.style,
                    radius: widget.radius,
                    height: widget.width,
                    hintText: widget.hintText,
                    onClear: widget.onClear,
                    autofocus: widget.autoFocus,
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
                child: Align(
                  alignment: widget.alignment,
                  child: widget.title,
                ),
              ),
            YaruSearchButton(
              icon: widget.searchIcon,
              selectedIcon: widget.searchIcon,
              style: widget.style == YaruSearchFieldStyle.outlined
                  ? widget.style
                  : YaruSearchFieldStyle.filled,
              radius: widget.radius,
              searchActive: _searchActive,
              onPressed: () => setState(() {
                _searchActive = !_searchActive;
                widget.onSearchActive?.call();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// A pre-styled [YaruIconButton], ideally used in combination with [YaruSearchField]
class YaruSearchButton extends StatelessWidget {
  const YaruSearchButton({
    super.key,
    this.searchActive,
    this.onPressed,
    this.size = kYaruTitleBarItemHeight,
    this.radius = const Radius.circular(kYaruTitleBarItemHeight),
    this.style = YaruSearchFieldStyle.filled,
    this.borderColor,
    this.icon,
    this.selectedIcon,
  });

  final bool? searchActive;
  final void Function()? onPressed;
  final double? size;
  final Radius radius;
  final YaruSearchFieldStyle style;
  final Color? borderColor;
  final Widget? icon;
  final Widget? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;

    return Center(
      widthFactor: 1,
      child: SizedBox(
        height: kYaruTitleBarItemHeight,
        width: kYaruTitleBarItemHeight,
        child: YaruIconButton(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radius),
              side: style == YaruSearchFieldStyle.filled
                  ? BorderSide.none
                  : BorderSide(
                      color: borderColor ??
                          theme.colorScheme.outline
                              .scale(lightness: light ? -0.1 : 0.1),
                      width: 1,
                    ),
            ),
          ),
          isSelected: searchActive,
          selectedIcon: selectedIcon ??
              Icon(
                YaruIcons.search,
                // Note: Center is needed for when the button is leading
                // This increases the iconsize, thus this adjustment is needed
                //
                size: kYaruIconSize - 4,
                color: theme.colorScheme.onSurface,
              ),
          icon: icon ??
              Icon(
                YaruIcons.search,
                size: kYaruIconSize - 4,
                color: theme.colorScheme.onSurface,
              ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

enum YaruSearchFieldStyle {
  outlined,
  filled,
  filledOutlined;
}
