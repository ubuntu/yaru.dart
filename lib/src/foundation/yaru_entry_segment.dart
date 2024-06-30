import 'package:flutter/foundation.dart';

enum YaruSegmentEventReturnAction {
  selectPreviousSegment,
  selectNextSegment,
  handled,
  ignored,
}

abstract interface class YaruEntrySegment implements Listenable {
  String? get input;
  String get text;
  int get length;

  void onSelect(bool selected);
  YaruSegmentEventReturnAction onInput(String input);
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
  @override
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
  YaruSegmentEventReturnAction onInput(String input) {
    var action = YaruSegmentEventReturnAction.handled;
    final previousInput = _input;

    if (_squashOnNextInput) {
      _input = null;
      _squashOnNextInput = false;
    }

    _input = (_input ?? '') + input;

    if (maxLength != null && _input!.length >= maxLength!) {
      _input = _input!.getNbFirstCharacter(maxLength!);
      action = YaruSegmentEventReturnAction.selectNextSegment;
    }

    if (_input != previousInput) notifyListeners();
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

typedef YaruNumericSegmentCallback = int? Function(
  String? input,
  int? value,
  int? oldValue,
)?;

class YaruNumericSegment extends ChangeNotifier implements YaruEntrySegment {
  /// Creates a [YaruNumericSegment].
  YaruNumericSegment({
    required this.minLength,
    required this.maxLength,
    int? initialValue,
    required this.placeholderLetter,
    this.onValueChange,
    this.onInputCallback,
    this.onDownArrowKeyCallback,
    this.onUpArrowKeyCallback,
  })  : assert(minLength > 0),
        assert(maxLength == null || maxLength >= minLength),
        _value = initialValue;

  /// Creates a [YaruNumericSegment] with a fixed length.
  YaruNumericSegment.fixed({
    required int length,
    int? initialValue,
    required this.placeholderLetter,
    this.onValueChange,
    this.onInputCallback,
    this.onDownArrowKeyCallback,
    this.onUpArrowKeyCallback,
  })  : assert(length > 0),
        _value = initialValue,
        minLength = length,
        maxLength = length;

  int? _value;
  int? get value => _value;
  set value(int? value) {
    final oldValue = _value;

    _value = onValueChange != null
        ? onValueChange!(
            _input,
            value,
            oldValue,
          )
        : value;
    if (maxLength != null && _value != null && _value!.length > maxLength!) {
      _value = oldValue;
    }

    if (_value != oldValue) notifyListeners();
  }

  String? _input;
  @override
  String? get input => _input;
  set input(String? input) {
    _input = input;
  }

  final YaruNumericSegmentCallback? onValueChange;
  final YaruNumericSegmentCallback? onInputCallback;
  final YaruNumericSegmentCallback? onUpArrowKeyCallback;
  final YaruNumericSegmentCallback? onDownArrowKeyCallback;

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
      final stringValue = value!.abs().toString();
      final remainCharactersLength = minLength - stringValue.length;

      if (value != null && value! < 0) {
        return '-${'0' * (remainCharactersLength - 2)}$stringValue';
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
  YaruSegmentEventReturnAction onInput(String userInput) {
    var action = YaruSegmentEventReturnAction.handled;
    final oldValue = _value;
    int? candidateValue;

    if (_squashOnNextInput) {
      _value = null;
      _input = null;
      _squashOnNextInput = false;
    }

    var candidateInput = (_input ?? '') + userInput;
    final intCandidateInput = candidateInput.maybeToInt;

    if (intCandidateInput != null) {
      if (maxLength != null && candidateInput.length >= maxLength!) {
        candidateInput = candidateInput.getNbFirstCharacter(maxLength!);
        action = YaruSegmentEventReturnAction.selectNextSegment;
      }
      _input = candidateInput;
      candidateValue = candidateInput.toInt;
    }

    value = onInputCallback != null
        ? onInputCallback!(_input, candidateValue, oldValue)
        : candidateValue;

    if (action == YaruSegmentEventReturnAction.selectNextSegment) {
      _input = null;
    }

    return action;
  }

  @override
  YaruSegmentEventReturnAction onBackspaceKey() {
    if (value != null) {
      input = null;
      value = null;
      return YaruSegmentEventReturnAction.handled;
    }
    return YaruSegmentEventReturnAction.selectPreviousSegment;
  }

  @override
  YaruSegmentEventReturnAction onUpArrowKey() {
    return _onArrowKey(1, 1, onUpArrowKeyCallback);
  }

  @override
  YaruSegmentEventReturnAction onDownArrowKey() {
    return _onArrowKey(-1, 0, onDownArrowKeyCallback);
  }

  YaruSegmentEventReturnAction _onArrowKey(
    int modifier,
    int defaultValue,
    YaruNumericSegmentCallback? callback,
  ) {
    final oldValue = value;
    int? candidateValue;

    if (value != null) {
      candidateValue = value! + modifier;
    } else {
      candidateValue = defaultValue;
    }

    input = null;
    value = callback != null
        ? callback(_input, candidateValue, oldValue)
        : candidateValue;

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

  @override
  String? get input => null;

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
