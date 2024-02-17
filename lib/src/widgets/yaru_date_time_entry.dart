import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/src/widgets/yaru_segmented_entry.dart';

import '../foundation/yaru_entry_segment.dart';

typedef SelectableDateTimePredicate = bool Function(DateTime dateTime);
typedef SelectableTimeOfDayPredicate = bool Function(TimeOfDay timeOfDay);

const maxMonthValue = 12;
const maxDayValue = 31;
const max24HourValue = 23;
const max12HourValue = 12;
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
    super.force24HourFormat,
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
    this.force24HourFormat,
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

  final bool? force24HourFormat;

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
      force24HourFormat: force24HourFormat,
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
    this.force24HourFormat,
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
  final IYaruDateTimeEntryController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// If provided, it will be used as the default value of the field.
  /// If null, we must provide a [controller].
  final DateTime? initialDateTime;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDateTime;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDateTime;

  final bool? force24HourFormat;

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
  late IYaruDateTimeEntryController _controller;
  YaruSegmentedEntryController? _entryController;

  late bool _is24HourLocalized;
  bool get _use24HourFormat => widget.force24HourFormat ?? _is24HourLocalized;

  late YaruNumericSegment _daySegment;
  late YaruNumericSegment _monthSegment;
  late YaruNumericSegment _yearSegment;
  late YaruNumericSegment _hourSegment;
  late YaruNumericSegment _minuteSegment;
  late YaruEnumSegment<DayPeriod> _periodSegment;

  final _segments = <YaruEntrySegment>[];
  final _delimiters = <String>[];

  int? get _year => _yearSegment.value;
  int? get _month => _monthSegment.value;
  int? get _day => _daySegment.value;
  int? get _hour => _hourSegment.value;
  int? get _minute => _minuteSegment.value;
  DayPeriod get _period => _periodSegment.value;

  bool get acceptEmpty => widget.acceptEmpty ?? true;

  // Used to avoid any controller value change while updating segments
  bool _cancelOnChanged = false;

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
      _daySegment.dispose();
      _monthSegment.dispose();
      _yearSegment.dispose();
      _hourSegment.dispose();
      _minuteSegment.dispose();
      _periodSegment.dispose();
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
    _periodSegment.dispose();

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
    _cancelOnChanged = true;
    _daySegment.value = _controller.dateTime?.day ?? _daySegment.value;
    _monthSegment.value = _controller.dateTime?.month ?? _monthSegment.value;
    _yearSegment.value = _controller.dateTime?.year ?? _yearSegment.value;
    _hourSegment.value = _controller.dateTime != null
        ? _use24HourFormat
            ? _controller.dateTime!.hour
            : _controller.dateTime!.toTimeOfDay().hourOfPeriod
        : _hourSegment.value;
    _minuteSegment.value = _controller.dateTime?.minute ?? _minuteSegment.value;
    _periodSegment.value = _controller.dateTime != null
        ? _controller.dateTime!.toTimeOfDay().period
        : _periodSegment.value;
    _cancelOnChanged = false;

    _onChanged();
  }

  YaruNumericSegmentCallback _dateTimeSegmentOnValueChange(
    int maxValue,
  ) {
    return (_, value, __) {
      if (value == null) {
        return value;
      }

      final effectiveMaxValue =
          _controller.dateTime == null ? maxValue : maxValue + 1;

      if (value > effectiveMaxValue) {
        return effectiveMaxValue;
      }

      return value;
    };
  }

  YaruNumericSegmentCallback _dateTimeSegmentOnInput(int maxValue) {
    return (input, value, oldValue) {
      if (_controller.dateTime == null && value != null && value < 0) {
        return 0;
      }

      if (value != null) {
        if (input?.length == 1 && value > maxValue.firstNumber && value < 10) {
          _entryController?.maybeSelectNextSegment();
        }

        if (value > maxValue) {
          return maxValue;
        }

        if (_controller.dateTime == null && value < 0) {
          return 0;
        }

        if (_controller.dateTime != null && value == 0) {
          return oldValue;
        }
      }

      return value;
    };
  }

  int? onYearValueChange(_, int? value, __) {
    if (value != null && value < 0) {
      return 0;
    }
    return value;
  }

  int? onHourUpArrowKey(_, int? value, int? oldValue) {
    if (_use24HourFormat) {
      return value;
    } else if (oldValue == 11) {
      if (_period.isPm && _daySegment.value != null) {
        _daySegment.value = _daySegment.value! + 1;
      }
      _periodSegment.value = _period.invert;
      return 12;
    } else if (oldValue == 12) {
      return 1;
    }
    return value;
  }

  int? onHourDownArrowKey(_, int? value, int? oldValue) {
    if (_use24HourFormat) {
      return value;
    } else if (oldValue == 12) {
      if (_period.isAm && _daySegment.value != null) {
        _daySegment.value = _daySegment.value! - 1;
      }
      _periodSegment.value = _period.invert;
      return 11;
    } else if (oldValue == 1) {
      return 12;
    }
    return value;
  }

  void _updateSegmentsAndDelimiters() {
    _segments.clear();
    _delimiters.clear();

    const year = 2001;
    const month = 12;
    const day = 31;

    final localizations = MaterialLocalizations.of(context);
    _is24HourLocalized =
        hourFormat(of: localizations.timeOfDayFormat()) != HourFormat.h;
    final formattedDateTime =
        localizations.formatCompactDate(DateTime(year, month, day));

    late final String yearPlaceholder;
    late final String monthPlaceholder;
    late final String dayPlaceholder;
    final dateDelimiter = localizations.dateSeparator;

    final dateParts = formattedDateTime.split(dateDelimiter);
    final dateHelpTextParts = localizations.dateHelpText.split(dateDelimiter);

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

    _daySegment = YaruNumericSegment.fixed(
      initialValue: _controller.dateTime?.day,
      length: 2,
      placeholderLetter: dayPlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxDayValue),
      onInputCallback: _dateTimeSegmentOnInput(maxDayValue),
    );

    _monthSegment = YaruNumericSegment.fixed(
      initialValue: _controller.dateTime?.month,
      length: 2,
      placeholderLetter: monthPlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxMonthValue),
      onInputCallback: _dateTimeSegmentOnInput(maxMonthValue),
    );

    _yearSegment = YaruNumericSegment(
      initialValue: _controller.dateTime?.year,
      minLength: widget.firstDateTime.year.toString().length,
      maxLength: widget.lastDateTime.year.toString().length,
      placeholderLetter: yearPlaceholder,
      onValueChange: onYearValueChange,
    );

    _periodSegment = YaruEnumSegment<DayPeriod>(
      initialValue: _controller.dateTime != null
          ? _controller.dateTime!.toTimeOfDay().period
          : DayPeriod.am,
      values: DayPeriod.values,
    );

    _hourSegment = YaruNumericSegment.fixed(
      initialValue: _controller.dateTime != null
          ? _use24HourFormat
              ? _controller.dateTime!.hour
              : _controller.dateTime!.toTimeOfDay().hourOfPeriod
          : null,
      length: 2,
      placeholderLetter: timePlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(
        _use24HourFormat ? max24HourValue : max12HourValue,
      ),
      onInputCallback: _dateTimeSegmentOnInput(
        _use24HourFormat ? max24HourValue : max12HourValue,
      ),
      onUpArrowKeyCallback: onHourUpArrowKey,
      onDownArrowKeyCallback: onHourDownArrowKey,
    );

    _minuteSegment = YaruNumericSegment.fixed(
      initialValue: _controller.dateTime?.minute,
      length: 2,
      placeholderLetter: timePlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxMinuteValue),
      onInputCallback: _dateTimeSegmentOnInput(maxMinuteValue),
    );

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
      _delimiters.addAll([dateDelimiter, dateDelimiter]);
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

      if (!_use24HourFormat) {
        _segments.add(_periodSegment);
        _delimiters.add(' ');
      }
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

  int _to24hour(int hour) {
    if (_period.isPm) {
      if (_hour! != 12) {
        return _hour! + 12;
      } else {
        return 12;
      }
    } else {
      if (_hour! != 12) {
        return _hour!;
      } else {
        return 0;
      }
    }
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
      (widget.type.hasDate && _year != null) ? _year! : 0,
      (widget.type.hasDate && _month != null) ? _month! : 1,
      (widget.type.hasDate && _day != null) ? _day! : 1,
      (widget.type.hasTime && _hour != null)
          ? _use24HourFormat
              ? _hour!
              : _to24hour(_hour!)
          : 0,
      (widget.type.hasTime && _minute != null) ? _minute! : 0,
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

  void _onChanged() {
    if (_cancelOnChanged) return;
    final dateTime = _tryParseSegments();
    _controller.dateTime = dateTime;
    widget.onChanged?.call(dateTime);
  }

  Widget _clearInputButton() {
    return IconButton(
      onPressed: () {
        _controller.dateTime = null;
        _daySegment.value = null;
        _monthSegment.value = null;
        _yearSegment.value = null;
        _hourSegment.value = null;
        _minuteSegment.value = null;
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
      onChanged: (_) => _onChanged(),
      onSaved: (_) => widget.onSaved?.call(_tryParseSegments()),
      onFieldSubmitted: (_) =>
          widget.onFieldSubmitted?.call(_tryParseSegments()),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _controller.dateTime = DateTime(2001, 12, 31);
              },
              icon: const Icon(YaruIcons.calendar),
            ),
            _clearInputButton(),
          ],
        ),
      ),
      keyboardType: TextInputType.datetime,
    );
  }
}

/// Common interface for a YaruDateTimeEntry controller.
/// See also :
/// - [YaruDateTimeEntryController], a controller for a [YaruDateTimeEntry].
/// - [YaruTimeEntryController], a controller for a [YaruTimeEntry].
abstract interface class IYaruDateTimeEntryController extends ChangeNotifier {
  DateTime? dateTime;
}

/// A controller for a [YaruDateTimeEntry].
/// See also :
/// - [YaruTimeEntryController], a controller for a [YaruTimeEntry].
class YaruDateTimeEntryController extends ValueNotifier<DateTime?>
    implements IYaruDateTimeEntryController {
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
    implements IYaruDateTimeEntryController {
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

extension _DayPeriodX on DayPeriod {
  bool get isAm => this == DayPeriod.am;
  bool get isPm => this == DayPeriod.pm;
  DayPeriod get invert => this == DayPeriod.pm ? DayPeriod.am : DayPeriod.pm;
}
