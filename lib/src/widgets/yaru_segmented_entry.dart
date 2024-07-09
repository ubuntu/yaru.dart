import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru/src/widgets/yaru_edge_focus_interceptor.dart';
import 'package:yaru/widgets.dart';

import '../foundation/yaru_entry_segment.dart';

/// An entry, split into multiple segments, which each represents a selectable editable part of the value.
/// This widget provides keyboard navigation, and numeric value manipulation, using keyboard arrow and tab keys.
///
/// See [YaruDateTimeEntry] for a good demo of how this widget works.
class YaruSegmentedEntry extends StatefulWidget {
  /// Creates a [YaruSegmentedEntry].
  const YaruSegmentedEntry({
    super.key,
    required this.segments,
    required this.delimiters,
    this.focusNode,
    this.autofocus,
    this.controller,
    this.decoration,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
  })  : assert(segments.length >= 0),
        assert(
          delimiters.length == segments.length - 1 ||
              segments.length == 0 && delimiters.length == 0,
        );

  /// A list of [YaruEntrySegment] which represent each selectable and editable part of this entry.
  final List<YaruEntrySegment> segments;

  /// A list of string, used to delimit segments.
  /// This list length have to be equal to [segments.length] - 1.
  /// The first delimiter will be placed between the first and the second segment,
  /// the second between the second and third segments, and so on.
  /// You can use a null delimiter if you want two segments to be stuck together.
  final List<String?> delimiters;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  ///
  /// If null, defaults to false.
  final bool? autofocus;

  /// A controller for this segmented entry.
  final YaruSegmentedEntryController? controller;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// An optional method that validates an input.
  final FormFieldValidator<String?>? validator;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSaved}
  final ValueChanged<String?>? onSaved;

  /// {@macro flutter.widgets.editableText.onFieldSubmitted}
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<YaruSegmentedEntry> createState() => _YaruSegmentedEntryState();
}

class _YaruSegmentedEntryState extends State<YaruSegmentedEntry> {
  bool _initialized = false;

  late FocusNode _focusNode;

  late YaruSegmentedEntryController _controller;
  final _textEditingController = TextEditingController();

  YaruEntrySegment get _selectedSegment => widget.segments[_controller.index];

  @override
  void initState() {
    super.initState();

    _updateEntryFocusNode();
    _focusNode.addListener(_initialFocusCallback);

    _updateController();
    _controller.addListener(_controllerCallback);
  }

  @override
  void didUpdateWidget(covariant YaruSegmentedEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      for (final segment in oldWidget.segments) {
        segment.removeListener(_segmentCallback);
      }
      for (final segment in widget.segments) {
        segment.addListener(_segmentCallback);
      }
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_initialFocusCallback);
      _updateEntryFocusNode();
      if (!_initialized) {
        _focusNode.addListener(_initialFocusCallback);
      }
    }

    if (widget.segments.length != oldWidget.segments.length ||
        widget.controller != oldWidget.controller) {
      _controller.removeListener(_controllerCallback);
      _updateController();
      _controller.addListener(_controllerCallback);
    }
  }

  @override
  void dispose() {
    for (final segment in widget.segments) {
      segment.removeListener(_segmentCallback);
    }
    _textEditingController.dispose();
    _focusNode.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _init() {
    if (_initialized) return;

    _initialized = true;
    for (final segment in widget.segments) {
      segment.addListener(_segmentCallback);
    }
    _updateTextEditingValue();
    _textEditingController.addListener(_textEditingControllerCallback);
  }

  void _updateEntryFocusNode() {
    final widgetOnKey = widget.focusNode?.onKeyEvent;
    _focusNode = widget.focusNode ?? FocusNode();

    if (widgetOnKey != null) {
      _focusNode.onKeyEvent = (node, event) =>
          widgetOnKey(node, event) == KeyEventResult.handled
              ? KeyEventResult.handled
              : _onKeyEvent(node, event);
    } else {
      _focusNode.onKeyEvent = _onKeyEvent;
    }
  }

  void _updateController() {
    _controller = widget.controller ??
        YaruSegmentedEntryController(
          length: widget.segments.length,
        );
  }

  void _updateTextEditingValue() {
    final oldText = _textEditingController.value.text;
    _textEditingController.value = _getTextEditingValue();

    if (_textEditingController.value.text != oldText) {
      widget.onChanged?.call(_textEditingController.value.text);
    }
  }

  void _initialFocusCallback() {
    if (_focusNode.hasFocus) {
      setState(() {
        _init();
        _focusNode.removeListener(_initialFocusCallback);
      });
    }
  }

  void _segmentCallback() => _updateTextEditingValue();

  void _controllerCallback() {
    _updateTextEditingValue();
    for (final segment in widget.segments) {
      segment.onSelect(false);
    }
    _selectedSegment.onSelect(true);
  }

  void _textEditingControllerCallback() {
    final selection = _textEditingController.selection.start;

    for (var i = 0; i < widget.segments.length; i++) {
      final baseOffset = _getBaseOffsetOfIndex(i);
      final extentOffset = _getExtentOffsetOfIndex(i);
      final isLastSegment = i == widget.segments.length - 1;
      final delimiterLength =
          !isLastSegment ? _getDelimiterOfIndex(i).length : 1;

      if (selection >= baseOffset &&
          selection < extentOffset + delimiterLength) {
        _controller.index = i;
        _updateTextEditingValue();
        break;
      }
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (widget.segments.isEmpty ||
        !(event is KeyDownEvent || event is KeyRepeatEvent)) {
      return KeyEventResult.ignored;
    }

    final ltr = Directionality.of(context) == TextDirection.ltr;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final tab = event.logicalKey == LogicalKeyboardKey.tab && !isShiftPressed;
    final shiftTab =
        event.logicalKey == LogicalKeyboardKey.tab && isShiftPressed;
    final arrowLeft = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final arrowRight = event.logicalKey == LogicalKeyboardKey.arrowRight;

    final left = (ltr ? shiftTab : tab) || arrowLeft;
    final right = (ltr ? tab : shiftTab) || arrowRight;
    final up = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final down = event.logicalKey == LogicalKeyboardKey.arrowDown;
    final backspace = event.logicalKey == LogicalKeyboardKey.backspace;

    late final YaruSegmentEventReturnAction action;

    if (left) {
      action = _controller.maybeSelectPreviousSegment()
          ? YaruSegmentEventReturnAction.handled
          : YaruSegmentEventReturnAction.ignored;
    } else if (right) {
      action = _controller.maybeSelectNextSegment()
          ? YaruSegmentEventReturnAction.handled
          : YaruSegmentEventReturnAction.ignored;
    } else if (up) {
      action = _selectedSegment.onUpArrowKey();
    } else if (down) {
      action = _selectedSegment.onDownArrowKey();
    } else if (backspace) {
      action = _selectedSegment.onBackspaceKey();
    } else {
      action = YaruSegmentEventReturnAction.ignored;
    }

    switch (action) {
      case YaruSegmentEventReturnAction.selectPreviousSegment:
        _controller.maybeSelectPreviousSegment();
        break;
      case YaruSegmentEventReturnAction.selectNextSegment:
        _controller.maybeSelectNextSegment();
        break;
      case YaruSegmentEventReturnAction.handled:
        break;
      case YaruSegmentEventReturnAction.ignored:
        return KeyEventResult.ignored;
    }

    _focusNode.requestFocus();
    return KeyEventResult.handled;
  }

  TextEditingValue _getTextEditingValue() {
    var text = '';

    for (var i = 0; i < widget.segments.length; i++) {
      final segment = widget.segments[i];
      text += segment.text + _getDelimiterOfIndex(i);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _getBaseOffsetOfIndex(
          _controller.index,
        ),
        extentOffset: _getExtentOffsetOfIndex(
          _controller.index,
        ),
      ),
    );
  }

  String _getDelimiterOfIndex(int index) {
    if (index < widget.delimiters.length) {
      return widget.delimiters[index] ?? '';
    }

    return '';
  }

  String _getPrefixOfIndex(int index) {
    if (index == 0) {
      return '';
    }

    var prefix = '';

    for (var i = 0; i < index; i++) {
      final segment = widget.segments[i];
      prefix += segment.text + _getDelimiterOfIndex(i);
    }

    return prefix;
  }

  String _getSuffixOfIndex(int index) {
    if (index >= widget.segments.length) {
      return '';
    }

    var prefix = _getDelimiterOfIndex(index);

    for (var i = index + 1; i < widget.segments.length; i++) {
      final segment = widget.segments[i];
      prefix += segment.text + _getDelimiterOfIndex(i);
    }

    return prefix;
  }

  int _getBaseOffsetOfIndex(int index) {
    if (index == 0 || widget.segments.isEmpty) {
      return 0;
    }

    var baseOffset = 0;

    for (var i = 0; i < index; i++) {
      baseOffset += widget.segments[i].length + _getDelimiterOfIndex(i).length;
    }

    return baseOffset;
  }

  int _getExtentOffsetOfIndex(int index) {
    return widget.segments.isNotEmpty
        ? _getBaseOffsetOfIndex(index) + widget.segments[index].length
        : 0;
  }

  TextEditingValue _valueFormatter(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (widget.segments.isEmpty) {
      return TextEditingValue.empty;
    }

    final prefix = _getPrefixOfIndex(_controller.index);
    final suffix = _getSuffixOfIndex(_controller.index);

    final input =
        newValue.text.replaceFirst(prefix, '').replaceFirst(suffix, '');

    final action = _selectedSegment.onInput(input);

    switch (action) {
      case YaruSegmentEventReturnAction.selectPreviousSegment:
        _controller.maybeSelectPreviousSegment();
        break;
      case YaruSegmentEventReturnAction.selectNextSegment:
        _controller.maybeSelectNextSegment();
        break;
      default:
    }

    return _getTextEditingValue();
  }

  void _onFocusFromEdge({required bool previous, required bool ltr}) {
    previous && ltr || !previous && !ltr
        ? _controller.selectFirstSegment()
        : _controller.selectLastSegment();
  }

  @override
  Widget build(BuildContext context) {
    final ltr = Directionality.of(context) == TextDirection.ltr;

    return YaruEdgeFocusInterceptor(
      onFocusFromPreviousNode: () => _onFocusFromEdge(
        previous: true,
        ltr: ltr,
      ),
      onFocusFromNextNode: () => _onFocusFromEdge(
        previous: false,
        ltr: ltr,
      ),
      child: TextFormField(
        focusNode: _focusNode,
        autofocus: widget.autofocus ?? false,
        controller: _textEditingController,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        mouseCursor: _initialized ? SystemMouseCursors.basic : null,
        showCursor: false,
        keyboardType: widget.keyboardType,
        decoration: widget.decoration,
        validator: widget.validator,
        inputFormatters: [
          TextInputFormatter.withFunction(_valueFormatter),
        ],
      ),
    );
  }
}
