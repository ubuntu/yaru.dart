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
  String _selectedSegmentInput = '';

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
    _selectedSegmentInput = '';
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
    if (widget.segments.isNotEmpty &&
        (event is RawKeyDownEvent || event.repeat)) {
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

      if (left) {
        if (!_controller.maybeSelectPreviousSegment() && (tab || shiftTab)) {
          return KeyEventResult.ignored;
        }
      } else if (right) {
        if (!_controller.maybeSelectNextSegment() && (tab || shiftTab)) {
          return KeyEventResult.ignored;
        }
      } else if (_selectedSegment.isNumeric && (up || down)) {
        final numericValue = int.tryParse(_selectedSegment.value) ?? 0;
        final input = numericValue + (up ? 1 : -1);
        _selectedSegment.input = input.toString();
      } else if (backspace) {
        if (_selectedSegment.input != null) {
          _selectedSegment.input = _selectedSegment.input!.dropLastCharacter;
          if (_selectedSegment.input!.isEmpty) {
            _selectedSegment.input = null;
            ltr
                ? _controller.maybeSelectPreviousSegment()
                : _controller.maybeSelectNextSegment();
          }
        } else {
          ltr
              ? _controller.maybeSelectPreviousSegment()
              : _controller.maybeSelectNextSegment();
        }
      }

      if (right || left || up || down || backspace) {
        _selectedSegmentInput = '';
        _focusNode.requestFocus();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  TextEditingValue _getTextEditingValue() {
    var text = '';

    for (var i = 0; i < widget.segments.length; i++) {
      final segment = widget.segments[i];
      text += segment.value + _getDelimiterOfIndex(i);
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
      prefix += segment.value + _getDelimiterOfIndex(i);
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
      prefix += segment.value + _getDelimiterOfIndex(i);
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

    final input = newValue.text
        .replaceFirst(prefix, '')
        .replaceFirst(suffix, '')
        .getNbFirstCharacter(_selectedSegment.maxLength);

    if (_selectedSegment.isNumeric && !input.isNumeric) {
      return _textEditingController.value;
    }

    _selectedSegmentInput += input;
    _selectedSegment.input =
        _selectedSegmentInput.getNbFirstCharacter(_selectedSegment.maxLength);

    if (_selectedSegmentInput.length >= _selectedSegment.maxLength) {
      if (!_controller.maybeSelectNextSegment()) {
        _focusNode.nextFocus();
      }
      _selectedSegmentInput = '';
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

typedef YaruEntrySegmentInputFormatter = String Function(
  String? segmentInput,
  int minLength,
  int maxLength,
);

/// Represents a single segment of a [YaruSegmentedEntry].
/// You can listen for [value] and [input] change using [addListener].
class YaruEntrySegment extends ChangeNotifier {
  /// Creates a [YaruEntrySegment].
  YaruEntrySegment({
    required this.minLength,
    required this.maxLength,
    String? intialInput,
    required this.inputFormatter,
    this.isNumeric = false,
  })  : assert(minLength > 0),
        assert(maxLength >= minLength),
        _value = inputFormatter(intialInput, minLength, maxLength);

  /// Creates a [YaruEntrySegment] with a fixed length.
  YaruEntrySegment.fixed({
    required int length,
    String? intialInput,
    required this.inputFormatter,
    this.isNumeric = false,
  })  : assert(length > 0),
        _value = inputFormatter(intialInput, length, length),
        minLength = length,
        maxLength = length;

  /// Minimal length of this segment.
  final int minLength;

  /// Maximal length of this segment.
  final int maxLength;

  /// If true, this segment will only accepts numeric values.
  /// This option also allows the value to be increased/decreased,
  /// using the up/down arrows keys of the keyboard.
  final bool isNumeric;

  /// Format the given user input into the real segment value.
  /// The returned string length have to be clamped between [minLength] and [maxLength].
  /// A null input will be given for an empty input, (ex: to display a placeholder).
  final YaruEntrySegmentInputFormatter inputFormatter;

  /// Length of the value of this segment.
  int get length => value.length;

  String? _input;
  String? get input => _input;
  set input(String? input) {
    final value = inputFormatter(input, minLength, maxLength);
    assert(value.length >= minLength);
    assert(value.length <= maxLength);
    _value = value;
    _input = input;
    notifyListeners();
  }

  String _value = '';
  String get value => _value;
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

extension _StringX on String {
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  String getNbFirstCharacter(int count) {
    return length > count ? substring(0, count) : this;
  }

  String get dropLastCharacter {
    return substring(0, length - 1);
  }
}
