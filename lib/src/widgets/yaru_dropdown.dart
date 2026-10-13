import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/yaru.dart';

const _kItemHeight = 40.0;

/// An entry of a [YaruDropdown].
class YaruDropdownEntry<T> {
  const YaruDropdownEntry({
    required T this.value,
    this.enabled = true,
    this.isDivider = false,
    this.child,
  });

  /// Creates a divider entry.
  const YaruDropdownEntry.divider()
    : value = null,
      enabled = false,
      isDivider = true,
      child = null;

  /// The value of the entry. Null for [YaruDropdownEntry.divider].
  final T? value;

  /// Whether the entry can be selected.
  final bool enabled;

  /// Whether the entry is a divider. Dividers are not focusable and are
  /// ignored by assistive technologies.
  final bool isDivider;

  /// An optional label for the entry. If null, [YaruDropdown.itemBuilder] is
  /// used. This also applies to an entry whose [value] is null, in which case
  /// `itemBuilder` is called with a null value; give such an entry a child.
  final Widget? child;
}

/// A dropdown that lets the user pick one value from a list of entries.
///
/// The button is exposed to assistive technologies as a button named after its
/// label followed by the current value, with its expanded state. The selected
/// entry is marked as selected in the menu and receives focus when the menu
/// opens.
///
/// While the menu is open, Tab and Shift+Tab cycle through the entries, like
/// a GTK dropdown, and Home, End, PageUp and PageDown jump through them.
///
/// Focus on the button is shown by highlighting the outline of the
/// [decoration]. Focus on an entry is shown by a [YaruFocusBorder] when
/// [YaruTheme] `focusBorders` is enabled.
///
/// ```dart
/// YaruDropdown<MyEnum>(
///   values: MyEnum.values,
///   selected: value,
///   onSelected: (value) => setState(() => this.value = value),
///   decoration: const InputDecoration(labelText: 'Label'),
///   itemBuilder: (context, value, _) => Text(value.name),
/// )
/// ```
class YaruDropdown<T> extends StatefulWidget {
  YaruDropdown({
    super.key,
    required this.itemBuilder,
    this.child,
    this.selected,
    List<T>? values,
    List<YaruDropdownEntry<T>>? entries,
    this.onSelected,
    this.iconBuilder,
    this.decoration = const InputDecoration(filled: false),
    this.style,
    this.menuStyle,
    this.menuPosition = PopupMenuPosition.under,
    this.itemStyle,
    this.expanded = true,
    this.semanticValue,
    this.focusNode,
    this.autofocus = false,
  }) : assert((entries != null) != (values != null)),
       entries =
           entries ?? [for (final v in values!) YaruDropdownEntry<T>(value: v)];

  /// An optional widget used as the label of the button instead of the
  /// selected entry.
  final Widget? child;

  /// The currently selected value.
  ///
  /// If null and no entry has a null value, nothing is selected. To let the
  /// user choose "none", use a nullable `T` and add an entry whose value is
  /// null, with a [YaruDropdownEntry.child] such as `Text('None')`.
  final T? selected;

  final List<YaruDropdownEntry<T>> entries;

  /// Called when the user selects an entry. If null, the dropdown is disabled.
  final ValueChanged<T>? onSelected;

  final ValueWidgetBuilder<T>? iconBuilder;

  /// Builds the label of the menu item (and of the button, when [child] is
  /// null) for a value.
  final ValueWidgetBuilder<T> itemBuilder;

  /// The decoration of the button. `labelText` is also used as the accessible
  /// name of the button.
  final InputDecoration decoration;

  final ButtonStyle? style;

  final MenuStyle? menuStyle;

  /// The position of the menu. Defaults to [PopupMenuPosition.under], which
  /// keeps the button visible while the menu is open.
  final PopupMenuPosition menuPosition;

  /// The style of the entries. Replaces the default, which hides the focus
  /// background so that only the focus border marks the focused entry.
  final ButtonStyle? itemStyle;

  /// Whether the button fills the available width. Defaults to true.
  final bool expanded;

  /// Overrides the current value announced by assistive technologies after the
  /// label. By default, the text of the button label is used if it is a [Text]
  /// widget.
  final String? semanticValue;

  /// An optional focus node for the button. If null, the dropdown manages its
  /// own.
  final FocusNode? focusNode;

  final bool autofocus;

  @override
  State<YaruDropdown<T>> createState() => _YaruDropdownState<T>();
}

class _YaruDropdownState<T> extends State<YaruDropdown<T>> {
  final _controller = MenuController();
  final _itemFocusNodes = <FocusNode>[];
  FocusNode? _internalFocusNode;
  bool _isOpen = false;
  bool _buttonFocused = false;
  Size? _size;

  FocusNode get _buttonFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  FocusNode _itemFocusNode(int index) {
    while (_itemFocusNodes.length <= index) {
      _itemFocusNodes.add(FocusNode());
    }
    return _itemFocusNodes[index];
  }

  @override
  void initState() {
    super.initState();
    _buttonFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (_buttonFocused != _buttonFocusNode.hasFocus) {
      setState(() => _buttonFocused = _buttonFocusNode.hasFocus);
    }
  }

  @override
  void didUpdateWidget(covariant YaruDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _onFocusChanged,
      );
      _buttonFocusNode.addListener(_onFocusChanged);
      _buttonFocused = _buttonFocusNode.hasFocus;
    }
    if (widget.entries.length < _itemFocusNodes.length) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _trimItemFocusNodes(),
      );
    }
  }

  void _trimItemFocusNodes() {
    if (!mounted) return;
    while (_itemFocusNodes.length > widget.entries.length) {
      _itemFocusNodes.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    _buttonFocusNode.removeListener(_onFocusChanged);
    _internalFocusNode?.dispose();
    for (final node in _itemFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// The index of the first entry matching [YaruDropdown.selected]. A null
  /// `selected` only matches an entry whose value is null (a "None" entry).
  int? get _selectedIndex {
    final index = widget.entries.indexWhere(
      (e) => !e.isDivider && e.value == widget.selected,
    );
    return index == -1 ? null : index;
  }

  /// The index of the entry that receives focus when the menu opens: the
  /// selected one if it is enabled, or else the first enabled one. Disabled
  /// entries cannot take focus.
  int? get _focusIndex {
    final selected = _selectedIndex;
    if (selected != null && widget.entries[selected].enabled) return selected;
    final index = widget.entries.indexWhere((e) => !e.isDivider && e.enabled);
    return index == -1 ? null : index;
  }

  static String? _textOf(Widget widget) {
    if (widget is Text) return widget.data ?? widget.textSpan?.toPlainText();
    return null;
  }

  Offset _menuOffset(Size? size) {
    switch (widget.menuPosition) {
      case PopupMenuPosition.under:
        return Offset(0, size?.height ?? 0);
      case PopupMenuPosition.over:
        final padding = MenuTheme.of(context).style?.padding
            ?.resolve({})
            ?.resolve(Directionality.of(context));
        return Offset(0, -(padding?.top ?? 8));
    }
  }

  TextStyle get _labelStyle =>
      Theme.of(context).textTheme.labelLarge!
          .copyWith(overflow: TextOverflow.ellipsis);

  void _toggle() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      final size = (context.findRenderObject() as RenderBox?)?.size;
      if (size != _size) setState(() => _size = size);
      _controller.open(position: _menuOffset(size));
    }
  }

  void _onOpen() {
    setState(() => _isOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final index = _focusIndex;
      final node = index == null ? null : _itemFocusNode(index);
      if (node != null && node.context != null) {
        _focusEntry(index!);
      } else {
        // No entry can take focus: keep it on the button, which closes the
        // menu on Escape.
        _buttonFocusNode.requestFocus();
      }
    });
  }

  void _onClose() {
    if (!mounted) return;
    setState(() => _isOpen = false);
    // Return focus after this frame has been built, so the button already
    // carries the newly selected value when assistive technologies read it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _buttonFocusNode.requestFocus();
    });
  }

  List<int> get _enabledIndices => [
    for (var i = 0; i < widget.entries.length; i++)
      if (!widget.entries[i].isDivider && widget.entries[i].enabled) i,
  ];

  void _focusEntry(int index) {
    final node = _itemFocusNode(index);
    node.requestFocus();
    final context = node.context;
    if (context != null) Scrollable.ensureVisible(context);
  }

  void _focusEdge({required bool last}) {
    final enabled = _enabledIndices;
    if (enabled.isNotEmpty) _focusEntry(last ? enabled.last : enabled.first);
  }

  void _cycleFocus({required bool forward}) {
    final enabled = _enabledIndices;
    if (enabled.isEmpty) return;
    final current = enabled.indexWhere((i) => _itemFocusNode(i).hasFocus);
    final next = current == -1
        ? (forward ? 0 : enabled.length - 1)
        : (current + (forward ? 1 : -1)) % enabled.length;
    _focusEntry(enabled[next]);
  }

  double? _top(int index) {
    final box = _itemFocusNode(index).context?.findRenderObject();
    return box is RenderBox && box.attached
        ? box.localToGlobal(Offset.zero).dy
        : null;
  }

  /// Moves focus about one viewport height up or down, stopping at the ends.
  void _focusPage({required bool down}) {
    final enabled = _enabledIndices;
    final from = enabled.indexWhere((i) => _itemFocusNode(i).hasFocus);
    if (from == -1) return;
    final step = down ? 1 : -1;
    final context = _itemFocusNode(enabled[from]).context;
    final viewport = context == null
        ? null
        : Scrollable.maybeOf(context)?.position.viewportDimension;
    final start = _top(enabled[from]);
    var target = (from + step).clamp(0, enabled.length - 1);
    if (viewport != null && start != null) {
      for (var i = target + step; i >= 0 && i < enabled.length; i += step) {
        final top = _top(enabled[i]);
        if (top == null || (top - start).abs() > viewport) break;
        target = i;
      }
    }
    _focusEntry(enabled[target]);
  }

  /// Handles keys only while the menu is open; the rest are left to the app.
  KeyEventResult _onMenuKey(KeyEvent event) {
    if (!_isOpen || event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.tab) {
      // Like a GTK popover, Tab cycles through the entries.
      _cycleFocus(forward: !HardwareKeyboard.instance.isShiftPressed);
    } else if (key == LogicalKeyboardKey.home) {
      _focusEdge(last: false);
    } else if (key == LogicalKeyboardKey.end) {
      _focusEdge(last: true);
    } else if (key == LogicalKeyboardKey.pageUp) {
      _focusPage(down: false);
    } else if (key == LogicalKeyboardKey.pageDown) {
      _focusPage(down: true);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onSelected != null;
    final selectedIndex = _selectedIndex;
    final label = widget.child != null
        ? widget.child!
        : selectedIndex != null
        ? widget.entries[selectedIndex].child ??
              widget.itemBuilder(context, widget.selected as T, null)
        : const SizedBox.shrink();
    final name = [
      widget.decoration.labelText,
      widget.semanticValue ?? _textOf(label),
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return MenuAnchor(
      controller: _controller,
      crossAxisUnconstrained: false,
      onOpen: _onOpen,
      onClose: _onClose,
      style:
          widget.menuStyle ??
          MenuStyle(
            minimumSize: WidgetStatePropertyAll(Size(_size?.width ?? 0, 0)),
            visualDensity: VisualDensity.standard,
          ),
      builder: (context, controller, child) => child!,
      menuChildren: [
        for (var i = 0; i < widget.entries.length; i++)
          _buildMenuItem(i, widget.entries[i], isSelected: i == selectedIndex),
      ],
      child: Stack(
        children: [
          // Paints the label only; the name is exposed by the button.
          Positioned.fill(
            child: ExcludeSemantics(
              child: InputDecorator(
                expands: true,
                decoration: widget.decoration,
                isEmpty: selectedIndex == null && widget.child == null,
                isFocused: _buttonFocused,
              ),
            ),
          ),
          Semantics(
            // Without `container`, neighbouring text is merged into the name.
            container: true,
            excludeSemantics: true,
            button: true,
            enabled: enabled,
            focusable: enabled,
            focused: enabled ? _buttonFocused : null,
            // The Linux embedder drops `Semantics.value`, so the value is part
            // of the name.
            label: name.isEmpty ? null : name,
            expanded: _isOpen,
            onTap: enabled ? _toggle : null,
            onFocus: enabled ? _buttonFocusNode.requestFocus : null,
            child: Focus(
              // Focus stays on the button when no entry is enabled; Tab must
              // not leave the open menu then.
              canRequestFocus: false,
              skipTraversal: true,
              includeSemantics: false,
              onKeyEvent: (_, event) => _onMenuKey(event),
              child: OutlinedButton(
                focusNode: _buttonFocusNode,
                autofocus: widget.autofocus,
                style:
                    widget.style ??
                    OutlinedButton.styleFrom(side: BorderSide.none),
                onPressed: enabled ? _toggle : null,
                child: Row(
                  mainAxisSize: widget.expanded
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: _labelStyle,
                      child: Flexible(child: label),
                    ),
                    const SizedBox(width: 8),
                    const Icon(YaruIcons.pan_down, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    int index,
    YaruDropdownEntry<T> item, {
    required bool isSelected,
  }) {
    if (item.isDivider) {
      return const Divider();
    }

    final value = item.value as T;
    final states = {
      if (isSelected) WidgetState.selected,
      if (widget.onSelected == null) WidgetState.disabled,
    };
    final button = OutlinedButtonTheme.of(context).style;
    final minimumSize = button?.minimumSize?.resolve(states);
    final maximumSize = button?.maximumSize?.resolve(states);

    return MergeSemantics(
      child: Semantics(
        selected: isSelected,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          includeSemantics: false,
          onKeyEvent: (_, event) => _onMenuKey(event),
          child: _withFocusBorder(
            MenuItemButton(
              focusNode: _itemFocusNode(index),
              leadingIcon: widget.iconBuilder?.call(context, value, null),
              onPressed: item.enabled
                  ? () => widget.onSelected?.call(value)
                  : null,
              style:
                  widget.itemStyle ??
                  MenuItemButton.styleFrom(
                    minimumSize: minimumSize ?? const Size(0, _kItemHeight),
                    maximumSize:
                        maximumSize ??
                        const Size(double.infinity, _kItemHeight),
                    padding: ButtonStyleButton.scaledPadding(
                      const EdgeInsets.symmetric(horizontal: 16),
                      const EdgeInsets.symmetric(horizontal: 8),
                      const EdgeInsets.symmetric(horizontal: 4),
                      MediaQuery.maybeOf(context)?.textScaler.scale(1) ?? 1,
                    ),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ).copyWith(
                    // The focus border marks the focused entry; hovering
                    // still highlights it.
                    overlayColor: WidgetStateProperty.resolveWith(
                      (states) =>
                          states.contains(WidgetState.focused) &&
                              !states.contains(WidgetState.hovered) &&
                              !states.contains(WidgetState.pressed)
                          ? Colors.transparent
                          : null,
                    ),
                  ),
              child: item.child ?? widget.itemBuilder(context, value, null),
            ),
          ),
        ),
      ),
    );
  }

  Widget _withFocusBorder(Widget item) {
    if (YaruTheme.maybeOf(context)?.focusBorders != true) return item;
    return YaruFocusBorder.primary(
      borderRadius: const BorderRadius.all(Radius.circular(kYaruButtonRadius)),
      borderStrokeAlign: BorderSide.strokeAlignInside,
      child: item,
    );
  }
}
