import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/src/widgets/yaru_segmented_entry.dart';

typedef SelectableDateTimePredicate = bool Function(DateTime dateTime);
typedef SelectableTimeOfDayPredicate = bool Function(TimeOfDay timeOfDay);

const maxMonthValue = 12;
const maxDayValue = 31;
const maxHourValue = 23;
const maxMinuteValue = 59;

const timePlaceholder = '-';
const timeDelimiter = ':';

/// A [YaruSegmentedEntry] configured to accepts and validates a datetime entered by a user.
///
/// [firstDateTime], [lastDateTime], and [selectableDateTimePredicate] provide constraints on
/// what days are valid. If the input datetime isn't in the datetime range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
///
/// See also:
/// - [YaruTimeEntry], a similar widget which only accepts time input.
class YaruDateTimeEntry extends _YaruDateTimeEntry {
  /// Creates a [YaruDateTimeEntry].
  ///
  /// A [YaruSegmentedEntry] configured to accepts and validates a datetime entered by a user.
  ///
  /// [firstDateTime], [lastDateTime], and [selectableDateTimePredicate] provide constraints on
  /// what days are valid. If the input datetime isn't in the datetime range or doesn't pass
  /// the given predicate, then the [errorInvalidText] message will be displayed
  /// under the field.
  const YaruDateTimeEntry({
    super.key,
    YaruDateTimeEntryController? controller,
    bool includeTime = true,
    super.focusNode,
    super.initialDateTime,
    required super.firstDateTime,
    required super.lastDateTime,
    super.onFieldSubmitted,
    super.onSaved,
    super.onChanged,
    super.selectableDateTimePredicate,
    super.errorFormatText,
    super.errorInvalidText,
    super.autofocus = false,
    super.acceptEmpty = true,
  }) : super(
          controller: controller,
          type: includeTime
              ? _YaruDateTimeEntryType.dateTime
              : _YaruDateTimeEntryType.date,
        );
}

/// A [YaruSegmentedEntry] configured to accepts and validates a time entered by a user.
///
/// [firstTime], [lastTime], and [selectableTimeOfDayPredicate] provide constraints on
/// what days are valid. If the input date isn't in the date range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
///
/// Under the hood, this widget is a simple adapter that converts [TimeOfDay] objects into [DateTime].
///
/// See also:
/// - [YaruDateTimeEntry], a similar widget which accepts date and time input.
class YaruTimeEntry extends StatelessWidget {
  /// Creates a [YaruTimeEntry].
  ///
  /// A [YaruSegmentedEntry] configured to accepts and validates a time entered by a user.
  ///
  /// [firstTime], [lastTime], and [selectableTimeOfDayPredicate] provide constraints on
  /// what days are valid. If the input date isn't in the date range or doesn't pass
  /// the given predicate, then the [errorInvalidText] message will be displayed
  /// under the field.
  const YaruTimeEntry({
    super.key,
    this.controller,
    this.focusNode,
    this.initialTimeOfDay,
    this.firstTime,
    this.lastTime,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.selectableTimeOfDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.autofocus,
    this.acceptEmpty,
  });

  /// A controller that can retrieve parsed [TimeOfDay] from the input and modify its value.
  final YaruTimeEntryController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// If provided, it will be used as the default value of the field.
  /// If null, we must provide a [controller].
  final TimeOfDay? initialTimeOfDay;

  /// The earliest allowable [TimeOfDay] that the user can input.
  final TimeOfDay? firstTime;

  /// The latest allowable [TimeOfDay] that the user can input.
  final TimeOfDay? lastTime;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field.
  final ValueChanged<TimeOfDay?>? onFieldSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save].
  final ValueChanged<TimeOfDay?>? onSaved;

  /// An optional method to call when the user is changing a value in the field.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Function to provide full control over which [TimeOfDay] can be selected.
  final SelectableTimeOfDayPredicate? selectableTimeOfDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstTime], later than
  /// [lastTime], or doesn't pass the [selectableTimeOfDayPredicate].
  final String? errorInvalidText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool? autofocus;

  /// Determines if an empty date would show [errorFormatText] or not.
  ///
  /// Defaults to false.
  ///
  /// If true, [errorFormatText] is not shown when the date input field is empty.
  final bool? acceptEmpty;

  static ValueChanged<DateTime?>? _valueChangedCallbackAdapter(
    ValueChanged<TimeOfDay?>? callback,
  ) {
    return (dateTime) => callback?.call(dateTime?.toTimeOfDay());
  }

  static SelectableDateTimePredicate? _predicateCallbackAdapter(
    SelectableTimeOfDayPredicate? callback,
  ) {
    return callback != null
        ? (dateTime) => callback.call(dateTime.toTimeOfDay())
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return _YaruDateTimeEntry(
      controller: controller,
      focusNode: focusNode,
      initialDateTime: initialTimeOfDay?.toDateTime(),
      firstDateTime:
          (firstTime ?? const TimeOfDay(hour: 0, minute: 0)).toDateTime(),
      lastDateTime:
          (lastTime ?? const TimeOfDay(hour: 23, minute: 59)).toDateTime(),
      onFieldSubmitted: _valueChangedCallbackAdapter(onFieldSubmitted),
      onSaved: _valueChangedCallbackAdapter(onSaved),
      onChanged: _valueChangedCallbackAdapter(onChanged),
      selectableDateTimePredicate:
          _predicateCallbackAdapter(selectableTimeOfDayPredicate),
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      autofocus: autofocus,
      acceptEmpty: acceptEmpty,
      type: _YaruDateTimeEntryType.time,
    );
  }
}

enum _YaruDateTimeEntryType {
  date,
  time,
  dateTime;

  bool get hasDate => this == date || this == dateTime;
  bool get hasTime => this == time || this == dateTime;
}

class _YaruDateTimeEntry extends StatefulWidget {
  const _YaruDateTimeEntry({
    super.key,
    required this.type,
    this.controller,
    this.focusNode,
    this.initialDateTime,
    required this.firstDateTime,
    required this.lastDateTime,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.selectableDateTimePredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.autofocus,
    this.acceptEmpty,
  })  : assert(initialDateTime == null || controller == null),
        assert((initialDateTime == null) != (controller == null));

  final _YaruDateTimeEntryType type;

  /// A controller that can retrieve parsed [DateTime] from the input and modify its value.
  final YaruDateTimeEntryControllerInterface? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// If provided, it will be used as the default value of the field.
  /// If null, we must provide a [controller].
  final DateTime? initialDateTime;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDateTime;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDateTime;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field.
  final ValueChanged<DateTime?>? onFieldSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save].
  final ValueChanged<DateTime?>? onSaved;

  /// An optional method to call when the user is changing a value in the field.
  final ValueChanged<DateTime?>? onChanged;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDateTimePredicate? selectableDateTimePredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDateTime], later than
  /// [lastDateTime], or doesn't pass the [selectableDateTimePredicate].
  final String? errorInvalidText;

  /// {@macro flutter.widgets.editableText.autofocus}
  ///
  /// If null, defaults to false.
  final bool? autofocus;

  /// Determines if an empty date would show [errorFormatText] or not.
  ///
  /// If true, [errorFormatText] is not shown when the date input field is empty.
  ///
  /// If null, defaults to true.
  final bool? acceptEmpty;

  @override
  State<_YaruDateTimeEntry> createState() => _YaruDateTimeEntryState();
}

class _YaruDateTimeEntryState extends State<_YaruDateTimeEntry> {
  late YaruDateTimeEntryControllerInterface _controller;
  YaruSegmentedEntryController? _entryController;

  late YaruEntrySegment _daySegment;
  late YaruEntrySegment _monthSegment;
  late YaruEntrySegment _yearSegment;
  late YaruEntrySegment _hourSegment;
  late YaruEntrySegment _minuteSegment;

  final _segments = <YaruEntrySegment>[];
  final _delimiters = <String>[];

  final _previousSegmentsValue = <YaruEntrySegment, int?>{};

  int? get _year => _yearSegment.value.maybeToInt;
  int? get _month => _monthSegment.value.maybeToInt;
  int? get _day => _daySegment.value.maybeToInt;
  int? get _hour => _hourSegment.value.maybeToInt;
  int? get _minute => _minuteSegment.value.maybeToInt;

  bool get acceptEmpty => widget.acceptEmpty ?? true;

  // Used to avoid any controller value change while updating segments
  bool _dirty = false;

  @override
  void initState() {
    super.initState();

    _updateController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateSegmentsAndDelimiters();
    _updateEntryController();
  }

  @override
  void didUpdateWidget(covariant _YaruDateTimeEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_controllerCallback);
      _updateController();
    }

    if (widget.type != oldWidget.type) {
      for (final segment in _segments) {
        segment.dispose();
      }
      _updateSegmentsAndDelimiters();

      _entryController?.dispose();
      _updateEntryController();
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      _controller.dispose();
    }

    _entryController?.dispose();
    _daySegment.dispose();
    _monthSegment.dispose();
    _yearSegment.dispose();
    _hourSegment.dispose();
    _minuteSegment.dispose();

    super.dispose();
  }

  void _updateController() {
    _controller = widget.controller ??
        YaruDateTimeEntryController(
          dateTime: widget.initialDateTime,
        );
    _controller.addListener(_controllerCallback);
  }

  void _controllerCallback() {
    _dirty = true;
    _daySegment.input = _controller.dateTime?.day.toString();
    _monthSegment.input = _controller.dateTime?.month.toString();
    _yearSegment.input = _controller.dateTime?.year.toString();
    _hourSegment.input = _controller.dateTime?.hour.toString();
    _minuteSegment.input = _controller.dateTime?.minute.toString();
    _dirty = false;

    widget.onChanged?.call(_tryParseSegments());
  }

  YaruEntrySegmentInputFormatter _dateTimeSegmentFormatter(
    String placeholderLetter,
  ) {
    return (input, minLength, _) {
      if (input != null) {
        final intInput = input.maybeToInt;
        final remainCharactersLength = minLength - input.length;

        if (intInput != null && intInput < 0) {
          return '-${'0' * (minLength - 2)}1';
        }

        return '0' * remainCharactersLength + input;
      }

      return placeholderLetter * minLength;
    };
  }

  void Function() _dateTimeSegmentListener(
    YaruEntrySegment segment,
    int maxValue,
  ) {
    return () {
      var segmentIntValue = segment.value.maybeToInt;
      final previousSegmentValue = _previousSegmentsValue[segment];
      final effectiveMaxValue =
          _controller.dateTime == null ? maxValue : maxValue + 1;

      if (segmentIntValue == previousSegmentValue) {
        return;
      }

      if (_controller.dateTime == null &&
          segmentIntValue != null &&
          segmentIntValue < 0) {
        segmentIntValue = 0;
        segment.input = segmentIntValue.toString();
      }

      if (segmentIntValue != null) {
        if (segmentIntValue > maxValue.firstNumber && segmentIntValue < 10) {
          if (previousSegmentValue == null ||
              !(previousSegmentValue + 1 == segmentIntValue ||
                  previousSegmentValue - 1 == segmentIntValue)) {
            _entryController?.maybeSelectNextSegment();
          }
        }

        if (segmentIntValue > effectiveMaxValue) {
          segment.input = effectiveMaxValue.toString();
          segmentIntValue = effectiveMaxValue;
        }
      }

      _previousSegmentsValue[segment] = segmentIntValue;
    };
  }

  void _updateSegmentsAndDelimiters() {
    _segments.clear();
    _delimiters.clear();

    const year = 2001;
    const month = 12;
    const day = 31;

    late final String yearPlaceholder;
    late final String monthPlaceholder;
    late final String dayPlaceholder;

    final localizations = MaterialLocalizations.of(context);
    final dateSeparator = localizations.dateSeparator;
    final formattedDateTime =
        localizations.formatCompactDate(DateTime(year, month, day));
    final dateParts = formattedDateTime.split(dateSeparator);
    final dateHelpTextParts = localizations.dateHelpText.split(dateSeparator);

    for (var i = 0; i < dateParts.length; i++) {
      final datePart = dateParts[i];
      final placeholder = dateHelpTextParts[i].firstCharacter;
      switch (datePart) {
        case '$year':
          yearPlaceholder = placeholder;
          break;
        case '$month':
          monthPlaceholder = placeholder;
          break;
        case '$day':
          dayPlaceholder = placeholder;
          break;
      }
    }

    _daySegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.day.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(dayPlaceholder),
    );
    _daySegment.addListener(_dateTimeSegmentListener(_daySegment, maxDayValue));

    _monthSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.month.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(monthPlaceholder),
    );
    _monthSegment
        .addListener(_dateTimeSegmentListener(_monthSegment, maxMonthValue));

    _yearSegment = YaruEntrySegment(
      intialInput: _controller.dateTime?.year.toString(),
      minLength: widget.firstDateTime.year.toString().length,
      maxLength: widget.lastDateTime.year.toString().length,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(yearPlaceholder),
    );
    _yearSegment.addListener(() {
      final intValue = _yearSegment.value.maybeToInt;
      if (_controller.dateTime != null && intValue != null && intValue < 0) {
        _yearSegment.input = '0';
      }
    });

    _hourSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.hour.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(timePlaceholder),
    );
    _hourSegment
        .addListener(_dateTimeSegmentListener(_hourSegment, maxHourValue));

    _minuteSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.minute.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(timePlaceholder),
    );
    _minuteSegment
        .addListener(_dateTimeSegmentListener(_minuteSegment, maxMinuteValue));

    for (final segment in _segments) {
      _previousSegmentsValue.addAll({segment: segment.value.maybeToInt});
    }

    if (widget.type.hasDate) {
      for (final datePart in dateParts) {
        switch (datePart) {
          case '$year':
            _segments.add(_yearSegment);
            break;
          case '$month':
            _segments.add(_monthSegment);
            break;
          case '$day':
            _segments.add(_daySegment);
            break;
        }
      }
      _delimiters.addAll([dateSeparator, dateSeparator]);
    }

    if (widget.type.hasTime) {
      _segments.addAll([
        _hourSegment,
        _minuteSegment,
      ]);

      if (widget.type.hasDate) {
        _delimiters.add(' ');
      }
      _delimiters.add(timeDelimiter);
    }
  }

  void _updateEntryController() {
    _entryController = YaruSegmentedEntryController(
      length: _segments.length,
      initialIndex: _entryController?.index.clamp(0, _segments.length - 1) ?? 0,
    );
  }

  bool _isValidAcceptableDate(DateTime? date) {
    return date != null &&
        !date.isBefore(widget.firstDateTime) &&
        !date.isAfter(widget.lastDateTime) &&
        (widget.selectableDateTimePredicate == null ||
            widget.selectableDateTimePredicate!(date));
  }

  DateTime? _tryParseSegments() {
    if (widget.type.hasDate &&
        (_year == null || _month == null || _day == null)) {
      return null;
    }

    if (widget.type.hasTime && (_hour == null || _minute == null)) {
      return null;
    }

    return DateTime(
      _year ?? 0,
      _month ?? 0,
      _day ?? 0,
      _hour ?? 0,
      _minute ?? 0,
    );
  }

  String? _validateDateTime(String? text) {
    final dateTime = _tryParseSegments();
    final localizations = MaterialLocalizations.of(context);

    if (dateTime == null) {
      if (_year == null &&
          _month == null &&
          _day == null &&
          _hour == null &&
          _minute == null &&
          acceptEmpty) {
        return null;
      }

      return widget.errorFormatText ?? localizations.invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(dateTime)) {
      return widget.errorInvalidText ?? localizations.dateOutOfRangeLabel;
    }

    return null;
  }

  Widget _clearInputButton() {
    return IconButton(
      onPressed: () {
        _controller.dateTime = null;
        for (final segment in _segments) {
          segment.input = null;
        }

        _entryController?.selectFirstSegment();
      },
      icon: const Icon(YaruIcons.edit_clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final labelText = widget.type == _YaruDateTimeEntryType.time
        ? localizations.timePickerInputHelpText
        : localizations.dateInputLabel;

    return YaruSegmentedEntry(
      focusNode: widget.focusNode,
      controller: _entryController,
      segments: _segments,
      delimiters: _delimiters,
      validator: _validateDateTime,
      onChanged: (_) {
        if (_dirty) return;
        final dateTime = _tryParseSegments();
        _controller.dateTime = dateTime;
        widget.onChanged?.call(dateTime);
      },
      onSaved: (_) => widget.onSaved?.call(_tryParseSegments()),
      onFieldSubmitted: (_) =>
          widget.onFieldSubmitted?.call(_tryParseSegments()),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: _clearInputButton(),
      ),
      keyboardType: TextInputType.datetime,
    );
  }
}

/// Common interface for a YaruDateTimeEntry controller.
/// See also :
/// - [YaruDateTimeEntryController], a controller for a [YaruDateTimeEntry].
/// - [YaruTimeEntryController], a controller for a [YaruTimeEntry].
abstract class YaruDateTimeEntryControllerInterface extends ChangeNotifier {
  DateTime? dateTime;
}

/// A controller for a [YaruDateTimeEntry].
/// See also :
/// - [YaruTimeEntryController], a controller for a [YaruTimeEntry].
class YaruDateTimeEntryController extends ValueNotifier<DateTime?>
    implements YaruDateTimeEntryControllerInterface {
  /// Creates a [YaruDateTimeEntryController].
  YaruDateTimeEntryController({DateTime? dateTime}) : super(dateTime);

  /// Creates a [YaruDateTimeEntryController], with the current datetime as initial value.
  YaruDateTimeEntryController.now() : super(DateTime.now());

  @override
  DateTime? get dateTime => value;
  @override
  set dateTime(DateTime? dateTime) => value = dateTime;
}

/// A controller for a [YaruTimeEntry].
/// See also :
/// - [YaruDateTimeEntryController], a controller for a [YaruDateTimeEntry].
class YaruTimeEntryController extends ValueNotifier<TimeOfDay?>
    implements YaruDateTimeEntryControllerInterface {
  /// Creates a [YaruTimeEntryController].
  YaruTimeEntryController({TimeOfDay? timeOfDay}) : super(timeOfDay);

  /// Creates a [YaruTimeEntryController], with the current time as initial value.
  YaruTimeEntryController.now() : super(TimeOfDay.now());

  @override
  @protected
  DateTime? get dateTime => value?.toDateTime();

  @override
  @protected
  set dateTime(DateTime? dateTime) => value = dateTime?.toTimeOfDay();

  TimeOfDay? get timeOfDay => value;
  set timeOfDay(TimeOfDay? timeOfDay) => value = timeOfDay;
}

extension _IntX on int {
  int get firstNumber {
    return int.parse(toString()[0]);
  }
}

extension _StringX on String {
  int? get maybeToInt {
    return int.tryParse(this);
  }

  String get firstCharacter {
    return length > 1 ? substring(0, 1) : this;
  }
}

extension _TimeOfDayX on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(
      0,
      1,
      1,
      hour,
      minute,
    );
  }
}

extension _DateTimeX on DateTime {
  TimeOfDay toTimeOfDay() {
    return TimeOfDay.fromDateTime(this);
  }
}
