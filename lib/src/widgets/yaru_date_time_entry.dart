import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
    super.clearIconSemanticLabel,
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
    this.clearIconSemanticLabel,
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

  /// If true, the hour will use the 24-hour format regardless of the ambient format.
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

  /// Optional semantic label to add to the clear button icon.
  final String? clearIconSemanticLabel;

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
      firstDateTime: (firstTime ?? const TimeOfDay(hour: 0, minute: 0))
          .toDateTime(),
      lastDateTime: (lastTime ?? const TimeOfDay(hour: 23, minute: 59))
          .toDateTime(),
      force24HourFormat: force24HourFormat,
      onFieldSubmitted: _valueChangedCallbackAdapter(onFieldSubmitted),
      onSaved: _valueChangedCallbackAdapter(onSaved),
      onChanged: _valueChangedCallbackAdapter(onChanged),
      selectableDateTimePredicate: _predicateCallbackAdapter(
        selectableTimeOfDayPredicate,
      ),
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      autofocus: autofocus,
      acceptEmpty: acceptEmpty,
      type: _YaruDateTimeEntryType.time,
      clearIconSemanticLabel: clearIconSemanticLabel,
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
    this.clearIconSemanticLabel,
  }) : assert(initialDateTime == null || controller == null),
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

  /// Optional semantic label to add to the clear button icon.
  final String? clearIconSemanticLabel;

  @override
  State<_YaruDateTimeEntry> createState() => YaruDateTimeEntryState();
}

@visibleForTesting
class YaruDateTimeEntryState extends State<_YaruDateTimeEntry> {
  late IYaruDateTimeEntryController dateTimeController;
  YaruSegmentedEntryController? segmentedEntryController;

  late bool is24HourLocalized;
  bool get use24HourFormat => widget.force24HourFormat ?? is24HourLocalized;

  late YaruNumericSegment daySegment;
  late YaruNumericSegment monthSegment;
  late YaruNumericSegment yearSegment;
  late YaruNumericSegment hourSegment;
  late YaruNumericSegment minuteSegment;
  late YaruEnumSegment<DayPeriod> periodSegment;

  final segments = <YaruEntrySegment>[];
  final delimiters = <String>[];

  int? get year => yearSegment.value;
  int? get month => monthSegment.value;
  int? get day => daySegment.value;
  int? get hour => hourSegment.value;
  int? get minute => minuteSegment.value;
  DayPeriod get period => periodSegment.value;

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
  // ignore: library_private_types_in_public_api
  void didUpdateWidget(covariant _YaruDateTimeEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      dateTimeController.removeListener(_controllerCallback);
      _updateController();
    }

    if (widget.type != oldWidget.type) {
      daySegment.dispose();
      monthSegment.dispose();
      yearSegment.dispose();
      hourSegment.dispose();
      minuteSegment.dispose();
      periodSegment.dispose();
      _updateSegmentsAndDelimiters();

      segmentedEntryController?.dispose();
      _updateEntryController();
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      dateTimeController.dispose();
    }

    segmentedEntryController?.dispose();
    daySegment.dispose();
    monthSegment.dispose();
    yearSegment.dispose();
    hourSegment.dispose();
    minuteSegment.dispose();
    periodSegment.dispose();

    super.dispose();
  }

  void _updateController() {
    dateTimeController =
        widget.controller ??
        YaruDateTimeEntryController(dateTime: widget.initialDateTime);
    dateTimeController.addListener(_controllerCallback);
  }

  void _controllerCallback() {
    _cancelOnChanged = true;
    daySegment.value = dateTimeController.dateTime?.day ?? daySegment.value;
    monthSegment.value =
        dateTimeController.dateTime?.month ?? monthSegment.value;
    yearSegment.value = dateTimeController.dateTime?.year ?? yearSegment.value;
    hourSegment.value = dateTimeController.dateTime != null
        ? use24HourFormat
              ? dateTimeController.dateTime!.hour
              : dateTimeController.dateTime!.toTimeOfDay().hourOfPeriod
        : hourSegment.value;
    minuteSegment.value =
        dateTimeController.dateTime?.minute ?? minuteSegment.value;
    periodSegment.value = dateTimeController.dateTime != null
        ? dateTimeController.dateTime!.toTimeOfDay().period
        : periodSegment.value;
    _cancelOnChanged = false;

    _onChanged();
  }

  YaruNumericSegmentCallback _dateTimeSegmentOnValueChange(int maxValue) {
    return (_, value, __) {
      if (value == null) {
        return value;
      }

      if (dateTimeController.dateTime == null && value < 0) {
        return 0;
      }

      final effectiveMaxValue = dateTimeController.dateTime == null
          ? maxValue
          : maxValue + 1;

      if (value > effectiveMaxValue) {
        return effectiveMaxValue;
      }

      return value;
    };
  }

  YaruNumericSegmentCallback _dateTimeSegmentOnInput(int maxValue) {
    return (input, value, oldValue) {
      if (dateTimeController.dateTime == null && value != null && value < 0) {
        return 0;
      }

      if (value != null) {
        if (input?.length == 1 && value > maxValue.firstNumber && value < 10) {
          segmentedEntryController?.maybeSelectNextSegment();
        }

        if (value > maxValue) {
          return maxValue;
        }

        if (dateTimeController.dateTime == null && value < 0) {
          return 0;
        }

        if (dateTimeController.dateTime != null && value == 0) {
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
    if (use24HourFormat) {
      return value;
    } else if (oldValue == 11) {
      if (period.isPm && daySegment.value != null) {
        daySegment.value = daySegment.value! + 1;
      }
      periodSegment.value = period.invert;
      return 12;
    } else if (oldValue == 12) {
      return 1;
    }
    return value;
  }

  int? onHourDownArrowKey(_, int? value, int? oldValue) {
    if (use24HourFormat) {
      return value;
    } else if (oldValue == 12) {
      if (period.isAm && daySegment.value != null) {
        daySegment.value = daySegment.value! - 1;
      }
      periodSegment.value = period.invert;
      return 11;
    } else if (oldValue == 1) {
      return 12;
    }
    return value;
  }

  void _updateSegmentsAndDelimiters() {
    segments.clear();
    delimiters.clear();

    const year = 2001;
    const month = 12;
    const day = 31;

    final localizations = MaterialLocalizations.of(context);
    is24HourLocalized =
        hourFormat(of: localizations.timeOfDayFormat()) != HourFormat.h;
    final formattedDateTime = localizations.formatCompactDate(
      DateTime(year, month, day),
    );

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

    daySegment = YaruNumericSegment.fixed(
      initialValue: dateTimeController.dateTime?.day,
      length: 2,
      placeholderLetter: dayPlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxDayValue),
      onInputCallback: _dateTimeSegmentOnInput(maxDayValue),
    );

    monthSegment = YaruNumericSegment.fixed(
      initialValue: dateTimeController.dateTime?.month,
      length: 2,
      placeholderLetter: monthPlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxMonthValue),
      onInputCallback: _dateTimeSegmentOnInput(maxMonthValue),
    );

    yearSegment = YaruNumericSegment(
      initialValue: dateTimeController.dateTime?.year,
      minLength: widget.firstDateTime.year.toString().length,
      maxLength: widget.lastDateTime.year.toString().length,
      placeholderLetter: yearPlaceholder,
      onValueChange: onYearValueChange,
    );

    periodSegment = YaruEnumSegment<DayPeriod>(
      initialValue: dateTimeController.dateTime != null
          ? dateTimeController.dateTime!.toTimeOfDay().period
          : DayPeriod.am,
      values: DayPeriod.values,
    );

    hourSegment = YaruNumericSegment.fixed(
      initialValue: dateTimeController.dateTime != null
          ? use24HourFormat
                ? dateTimeController.dateTime!.hour
                : dateTimeController.dateTime!.toTimeOfDay().hourOfPeriod
          : null,
      length: 2,
      placeholderLetter: timePlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(
        use24HourFormat ? max24HourValue : max12HourValue,
      ),
      onInputCallback: _dateTimeSegmentOnInput(
        use24HourFormat ? max24HourValue : max12HourValue,
      ),
      onUpArrowKeyCallback: onHourUpArrowKey,
      onDownArrowKeyCallback: onHourDownArrowKey,
    );

    minuteSegment = YaruNumericSegment.fixed(
      initialValue: dateTimeController.dateTime?.minute,
      length: 2,
      placeholderLetter: timePlaceholder,
      onValueChange: _dateTimeSegmentOnValueChange(maxMinuteValue),
      onInputCallback: _dateTimeSegmentOnInput(maxMinuteValue),
    );

    if (widget.type.hasDate) {
      for (final datePart in dateParts) {
        switch (datePart) {
          case '$year':
            segments.add(yearSegment);
            break;
          case '$month':
            segments.add(monthSegment);
            break;
          case '$day':
            segments.add(daySegment);
            break;
        }
      }
      delimiters.addAll([dateDelimiter, dateDelimiter]);
    }

    if (widget.type.hasTime) {
      segments.addAll([hourSegment, minuteSegment]);

      if (widget.type.hasDate) {
        delimiters.add(' ');
      }
      delimiters.add(timeDelimiter);

      if (!use24HourFormat) {
        segments.add(periodSegment);
        delimiters.add(' ');
      }
    }
  }

  void _updateEntryController() {
    segmentedEntryController = YaruSegmentedEntryController(
      length: segments.length,
      initialIndex:
          segmentedEntryController?.index.clamp(0, segments.length - 1) ?? 0,
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
    if (widget.type.hasDate && (year == null || month == null || day == null)) {
      return null;
    }

    if (widget.type.hasTime && (hour == null || minute == null)) {
      return null;
    }

    int to24hour(int hour) {
      if (period.isPm) {
        if (hour != 12) {
          return hour + 12;
        } else {
          return 12;
        }
      } else {
        if (hour != 12) {
          return hour;
        } else {
          return 0;
        }
      }
    }

    return DateTime(
      (widget.type.hasDate && year != null) ? year! : 0,
      (widget.type.hasDate && month != null) ? month! : 1,
      (widget.type.hasDate && day != null) ? day! : 1,
      (widget.type.hasTime && hour != null)
          ? use24HourFormat
                ? hour!
                : to24hour(hour!)
          : 0,
      (widget.type.hasTime && minute != null) ? minute! : 0,
    );
  }

  String? _validateDateTime(String? text) {
    final dateTime = _tryParseSegments();
    final localizations = MaterialLocalizations.of(context);

    if (dateTime == null) {
      if (year == null &&
          month == null &&
          day == null &&
          hour == null &&
          minute == null &&
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
    dateTimeController.dateTime = dateTime;
    widget.onChanged?.call(dateTime);
  }

  Widget _clearInputButton() {
    return YaruIconButton(
      onPressed: () {
        _cancelOnChanged = true;
        daySegment.value = null;
        monthSegment.value = null;
        yearSegment.value = null;
        hourSegment.value = null;
        minuteSegment.value = null;
        dateTimeController.dateTime = null;
        _cancelOnChanged = false;

        _onChanged();
      },
      icon: Icon(
        YaruIcons.edit_clear,
        semanticLabel: widget.clearIconSemanticLabel,
      ),
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
      controller: segmentedEntryController,
      segments: segments,
      delimiters: delimiters,
      validator: _validateDateTime,
      onChanged: (_) => _onChanged(),
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
    return DateTime(0, 1, 1, hour, minute);
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
