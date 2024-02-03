import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaru_widgets/src/widgets/yaru_edge_focus_interceptor.dart';
import 'package:yaru_widgets/widgets.dart';

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
    if (!listEquals(widget.segments, oldWidget.segments) && _initialized) {
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
    _initialized = true;
    for (final segment in widget.segments) {
      segment.addListener(_segmentCallback);
    }
    _updateTextEditingValue();
    _textEditingController.addListener(_textEditingControllerCallback);
  }

  void _updateEntryFocusNode() {
    final widgetOnKey = widget.focusNode?.onKey;
    _focusNode = widget.focusNode ?? FocusNode();

    if (widgetOnKey != null) {
      _focusNode.onKey = (node, event) =>
          widgetOnKey(node, event) == KeyEventResult.handled
              ? KeyEventResult.handled
              : _onKey(node, event);
    } else {
      _focusNode.onKey = _onKey;
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

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    if (widget.segments.isEmpty ||
        !(event is RawKeyDownEvent || event.repeat)) {
      return KeyEventResult.ignored;
    }

    final ltr = Directionality.of(context) == TextDirection.ltr;
    final tab =
        event.logicalKey == LogicalKeyboardKey.tab && !event.isShiftPressed;
    final shiftTab =
        event.logicalKey == LogicalKeyboardKey.tab && event.isShiftPressed;
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

enum YaruSegmentEventReturnAction {
  selectPreviousSegment,
  selectNextSegment,
  handled,
  ignored,
}

abstract interface class YaruEntrySegment implements Listenable {
  String get text;
  int get length;

  void onSelect(bool selected);
  YaruSegmentEventReturnAction onInput(String? input);
  YaruSegmentEventReturnAction onUpArrowKey();
  YaruSegmentEventReturnAction onDownArrowKey();
  YaruSegmentEventReturnAction onBackspaceKey();
}

typedef YaruSegmentInputFormatter = String Function(
  String? segmentInput,
  int minLength,
  int? maxLength,
);

/// Represents a single segment of a [YaruSegmentedEntry].
/// You can listen for [text] and [input] change using [addListener].
class YaruStringSegment extends ChangeNotifier implements YaruEntrySegment {
  /// Creates a [YaruStringSegment].
  YaruStringSegment({
    this.minLength = 1,
    required this.maxLength,
    String? intialInput,
    required this.inputFormatter,
  })  : assert(minLength > 0),
        assert(maxLength == null || maxLength >= minLength);

  /// Creates a [YaruStringSegment] with a fixed length.
  YaruStringSegment.fixed({
    required int length,
    String? intialInput,
    required this.inputFormatter,
  })  : assert(length > 0),
        minLength = length,
        maxLength = length;

  /// Minimal length of this segment.
  final int minLength;

  /// Maximal length of this segment.
  final int? maxLength;

  /// Format the given user input into the real segment value.
  /// The returned string length have to be clamped between [minLength] and [maxLength].
  /// A null input will be given for an empty input, (ex: to display a placeholder).
  final YaruSegmentInputFormatter inputFormatter;

  @override
  String get text {
    final text = inputFormatter(_input, minLength, maxLength);
    assert(text.length >= minLength);
    assert(maxLength == null || text.length <= maxLength!);
    return text;
  }

  @override
  int get length => text.length;

  String? _input;
  String? get input => _input;

  bool _selected = false;
  bool _squashOnNextInput = false;

  @override
  void onSelect(bool selected) {
    if (_selected == false && selected == true) {
      _squashOnNextInput = true;
    }
    _selected = selected;
  }

  @override
  YaruSegmentEventReturnAction onInput(String? input, {bool squash = false}) {
    var action = YaruSegmentEventReturnAction.handled;
    final oldInput = _input;

    if (_squashOnNextInput || squash) {
      _input = null;
      _squashOnNextInput = false;
    }

    if (input == null) {
      _input = null;
    } else {
      _input = (_input ?? '') + input;

      if (maxLength != null && _input!.length >= maxLength!) {
        _input = _input!.getNbFirstCharacter(maxLength!);
        action = YaruSegmentEventReturnAction.selectNextSegment;
      }
    }

    if (_input != oldInput) notifyListeners();
    return action;
  }

  @override
  YaruSegmentEventReturnAction onBackspaceKey() {
    if (_input != null) {
      _input = null;
      notifyListeners();
      return YaruSegmentEventReturnAction.handled;
    }

    return YaruSegmentEventReturnAction.selectPreviousSegment;
  }

  @override
  YaruSegmentEventReturnAction onDownArrowKey() =>
      YaruSegmentEventReturnAction.ignored;

  @override
  YaruSegmentEventReturnAction onUpArrowKey() =>
      YaruSegmentEventReturnAction.ignored;
}

class YaruNumericSegment extends ChangeNotifier implements YaruEntrySegment {
  /// Creates a [YaruNumericSegment].
  YaruNumericSegment({
    required this.minLength,
    required this.maxLength,
    int? initialValue,
    required this.placeholderLetter,
  })  : assert(minLength > 0),
        assert(maxLength == null || maxLength >= minLength),
        _value = initialValue;

  /// Creates a [YaruNumericSegment] with a fixed length.
  YaruNumericSegment.fixed({
    required int length,
    int? initialValue,
    required this.placeholderLetter,
  })  : assert(length > 0),
        _value = initialValue,
        minLength = length,
        maxLength = length;

  int? _value;
  int? get value => _value;
  set value(int? value) {
    _value = value;
    notifyListeners();
  }

  String? _input;
  String? get input => _input;

  final String placeholderLetter;

  /// Minimal length of this segment.
  final int minLength;

  /// Maximal length of this segment.
  final int? maxLength;

  bool _selected = false;
  bool _squashOnNextInput = false;

  @override
  String get text {
    final text = _formatValue();
    assert(text.length >= minLength);
    assert(maxLength == null || text.length <= maxLength!);
    return text;
  }

  String _formatValue() {
    if (value != null) {
      final stringValue = value!.toString();
      final remainCharactersLength = minLength - stringValue.length;

      if (value != null && value! < 0) {
        return '-${'0' * (minLength - 2)}1';
      }

      return '0' * remainCharactersLength + stringValue;
    }

    return placeholderLetter * minLength;
  }

  @override
  int get length => text.length;

  @override
  void onSelect(bool selected) {
    if (_selected == false && selected == true) {
      _squashOnNextInput = true;
    }
    _selected = selected;
  }

  @override
  YaruSegmentEventReturnAction onInput(String? input, {bool squash = false}) {
    // TODO: take every letters in account (0)
    var action = YaruSegmentEventReturnAction.handled;

    if (_squashOnNextInput || squash) {
      value = null;
      _squashOnNextInput = false;
    }

    final intInput = input?.maybeToInt;

    if (input != null && intInput == null) {
      return YaruSegmentEventReturnAction.handled;
    } else if (intInput == null) {
      value = null;
    } else {
      value = value != null ? value!.concatenate(intInput) : intInput;

      if (maxLength != null && value!.length >= maxLength!) {
        value = value!.getNbFirstNumber(maxLength!);
        action = YaruSegmentEventReturnAction.selectNextSegment;
      }
    }

    return action;
  }

  @override
  YaruSegmentEventReturnAction onBackspaceKey() {
    if (value != null) {
      value = null;
      return YaruSegmentEventReturnAction.handled;
    }

    return YaruSegmentEventReturnAction.selectPreviousSegment;
  }

  @override
  YaruSegmentEventReturnAction onUpArrowKey() {
    if (value != null) {
      value = value! + 1;
    } else {
      value = 1;
    }
    notifyListeners();
    return YaruSegmentEventReturnAction.handled;
  }

  @override
  YaruSegmentEventReturnAction onDownArrowKey() {
    if (value != null) {
      value = value! - 1;
    } else {
      value = 0;
    }
    notifyListeners();
    return YaruSegmentEventReturnAction.handled;
  }
}

class YaruEnumSegment<T extends Enum> extends ChangeNotifier
    implements YaruEntrySegment {
  YaruEnumSegment({
    T? initialValue,
    required this.values,
  }) : value = initialValue ?? values.first;

  T value;

  int get _valueIndex => values.indexOf(value);

  final List<T> values;

  @override
  String get text => value.name.toString();

  @override
  int get length => text.length;

  @override
  YaruSegmentEventReturnAction onInput(String? input) {
    if (input == null) {
      return YaruSegmentEventReturnAction.handled;
    }

    value = values.firstWhere(
      (e) => e.name.toString().startsWith(input),
      orElse: () => value,
    );
    notifyListeners();
    return YaruSegmentEventReturnAction.handled;
  }

  @override
  YaruSegmentEventReturnAction onUpArrowKey() {
    if (_valueIndex + 1 < values.length) {
      value = values[_valueIndex + 1];
    } else {
      value = values[0];
    }
    notifyListeners();
    return YaruSegmentEventReturnAction.handled;
  }

  @override
  YaruSegmentEventReturnAction onDownArrowKey() {
    if (_valueIndex - 1 >= 0) {
      value = values[_valueIndex - 1];
    } else {
      value = values[values.length - 1];
    }
    notifyListeners();
    return YaruSegmentEventReturnAction.handled;
  }

  @override
  YaruSegmentEventReturnAction onBackspaceKey() {
    return YaruSegmentEventReturnAction.selectPreviousSegment;
  }

  @override
  void onSelect(bool selected) {}
}

/// A controller for a [YaruSegmentedEntry].
class YaruSegmentedEntryController extends ChangeNotifier {
  /// Creates a [YaruSegmentedEntryController].
  YaruSegmentedEntryController({
    required this.length,
    int initialIndex = 0,
  })  : assert(initialIndex >= 0 && initialIndex < length || length == 0),
        assert(length >= 0),
        _index = initialIndex;

  /// Number of segments. Must correspond to [YaruSegmentedEntry.segments.length].
  final int length;

  int _index;
  int get index => _index;
  set index(int index) {
    assert(index >= 0 && index < length);

    if (index == _index) {
      return;
    }

    _index = index;
    notifyListeners();
  }

  /// Selects the previous segment if possible.
  /// Returns true if successful.
  bool maybeSelectPreviousSegment() {
    if (_index - 1 >= 0) {
      index--;
      return true;
    }
    return false;
  }

  /// Selects the next segment if possible.
  /// Returns true if successful.
  bool maybeSelectNextSegment() {
    if (_index + 1 < length) {
      index++;
      return true;
    }
    return false;
  }

  /// Selects the first segment.
  void selectFirstSegment() {
    index = 0;
  }

  /// Selects the last segment.
  void selectLastSegment() {
    index = length - 1;
  }
}

extension _IntX on int {
  int concatenate(int other) {
    return (toString() + other.toString()).toInt;
  }

  int getNbFirstNumber(int count) {
    final string = toString();
    return string.length > count ? string.substring(0, count).toInt : this;
  }

  int get length {
    return toString().length;
  }
}

extension _StringX on String {
  int? get maybeToInt {
    return int.tryParse(this);
  }

  int get toInt {
    return int.parse(this);
  }

  String getNbFirstCharacter(int count) {
    return length > count ? substring(0, count) : this;
  }
}
