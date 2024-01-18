import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/src/widgets/yaru_segmented_entry.dart';

/// A [YaruSegmentedEntry] configured to accepts and validates a datetime entered by a user.
///
/// [firstDate], [lastDate], and [selectableDayPredicate] provide constraints on
/// what days are valid. If the input date isn't in the date range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
class YaruDateTimeEntry extends StatefulWidget {
  /// Creates a [YaruDateTimeEntry].
  const YaruDateTimeEntry({
    super.key,
    this.controller,
    this.focusNode,
    this.initialDateTime,
    required this.firstDate,
    required this.lastDate,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.autofocus = false,
    this.acceptEmptyDate = true,
  })  : assert(initialDateTime == null || controller == null),
        assert((initialDateTime == null) != (controller == null));

  final YaruDateTimeEntryController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// If provided, it will be used as the default value of the field.
  final DateTime? initialDateTime;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field.
  final ValueChanged<DateTime?>? onFieldSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save].
  final ValueChanged<DateTime?>? onSaved;

  /// An optional method to call when the user is changing a value in the field.
  final ValueChanged<DateTime?>? onChanged;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Determines if an empty date would show [errorFormatText] or not.
  ///
  /// Defaults to false.
  ///
  /// If true, [errorFormatText] is not shown when the date input field is empty.
  final bool acceptEmptyDate;

  @override
  State<YaruDateTimeEntry> createState() => _YaruDateTimeEntryState();
}

class _YaruDateTimeEntryState extends State<YaruDateTimeEntry> {
  late YaruDateTimeEntryController _controller;
  YaruSegmentedEntryController? _entryController;

  late YaruEntrySegment _daySegment;
  late YaruEntrySegment _monthSegment;
  late YaruEntrySegment _yearSegment;
  late YaruEntrySegment _hourSegment;
  late YaruEntrySegment _minuteSegment;
  late YaruEntrySegment _secondSegment;

  final _segments = <YaruEntrySegment>[];
  final _delimiters = <String>[];

  final _previousSegmentsValue = <YaruEntrySegment, int?>{};

  int? get _year => _yearSegment.value.maybeToInt;
  int? get _month => _monthSegment.value.maybeToInt;
  int? get _day => _daySegment.value.maybeToInt;
  int? get _hour => _hourSegment.value.maybeToInt;
  int? get _minute => _minuteSegment.value.maybeToInt;
  int? get _second => _secondSegment.value.maybeToInt;

  @override
  void initState() {
    super.initState();

    _updateController();
    _controller.addListener(_controllerCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateSegmentsAndDelimiters();
    _entryController = YaruSegmentedEntryController(
      length: _segments.length,
      initialIndex: _entryController?.index.clamp(0, _segments.length - 1) ?? 0,
    );
  }

  @override
  void didUpdateWidget(covariant YaruDateTimeEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_controllerCallback);
      _updateController();
      _controller.addListener(_controllerCallback);
    }
  }

  @override
  void dispose() {
    _entryController?.dispose();
    _daySegment.dispose();
    _monthSegment.dispose();
    _yearSegment.dispose();
    _hourSegment.dispose();
    _minuteSegment.dispose();
    _secondSegment.dispose();

    super.dispose();
  }

  void _updateController() {
    _controller = widget.controller ??
        YaruDateTimeEntryController(
          dateTime: widget.initialDateTime,
        );
  }

  void _controllerCallback() {
    _daySegment.input = _controller.dateTime?.day.toString();
    _monthSegment.input = _controller.dateTime?.month.toString();
    _yearSegment.input = _controller.dateTime?.year.toString();
    _hourSegment.input = _controller.dateTime?.hour.toString();
    _minuteSegment.input = _controller.dateTime?.minute.toString();
    _secondSegment.input = _controller.dateTime?.second.toString();
  }

  YaruEntrySegmentInputFormatter _dateTimeSegmentFormatter(
    String placeholderLetter,
  ) {
    return (input, minLength, _) {
      if (input != null) {
        final remainCharactersLength = minLength - input.length;
        return '0' * remainCharactersLength + input;
      }

      return placeholderLetter * minLength;
    };
  }

  void Function() _dateTimeSegmentListener(
    YaruEntrySegment segment,
    int maxFirstValue,
    int maxValue,
  ) {
    return () {
      var segmentIntValue = segment.value.maybeToInt;
      final previousSegmentValue = _previousSegmentsValue[segment];

      if (segmentIntValue != null) {
        if (segmentIntValue > maxFirstValue && segmentIntValue < 10) {
          if (previousSegmentValue == null ||
              !(previousSegmentValue + 1 == segmentIntValue ||
                  previousSegmentValue - 1 == segmentIntValue)) {
            _entryController?.maybeSelectNextSegment();
          }
        }

        if (segmentIntValue > maxValue) {
          segment.input = maxValue.toString();
          segmentIntValue = maxValue;
        }
      }

      _previousSegmentsValue[segment] = segmentIntValue;
    };
  }

  void _updateSegmentsAndDelimiters() {
    for (final segment in _segments) {
      segment.dispose();
    }

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
    _daySegment.addListener(_dateTimeSegmentListener(_daySegment, 3, 31));

    _monthSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.month.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(monthPlaceholder),
    );
    _monthSegment.addListener(_dateTimeSegmentListener(_monthSegment, 1, 12));

    _yearSegment = YaruEntrySegment(
      intialInput: _controller.dateTime?.year.toString(),
      minLength: widget.firstDate.year.toString().length,
      maxLength: widget.lastDate.year.toString().length,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter(yearPlaceholder),
    );

    _hourSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.hour.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('-'),
    );
    _hourSegment.addListener(_dateTimeSegmentListener(_hourSegment, 2, 23));

    _minuteSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.minute.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('-'),
    );
    _minuteSegment.addListener(_dateTimeSegmentListener(_minuteSegment, 5, 59));

    _secondSegment = YaruEntrySegment.fixed(
      intialInput: _controller.dateTime?.second.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('-'),
    );
    _secondSegment.addListener(_dateTimeSegmentListener(_secondSegment, 5, 59));

    for (final segment in _segments) {
      _previousSegmentsValue.addAll({segment: segment.value.maybeToInt});
    }

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

    _segments.addAll([
      _hourSegment,
      _minuteSegment,
      _secondSegment,
    ]);

    _delimiters.addAll([dateSeparator, dateSeparator, ' ', ':', ':']);
  }

  bool _isValidAcceptableDate(DateTime? date) {
    return date != null &&
        !date.isBefore(widget.firstDate) &&
        !date.isAfter(widget.lastDate) &&
        (widget.selectableDayPredicate == null ||
            widget.selectableDayPredicate!(date));
  }

  DateTime? _tryParseSegments() {
    if (_year == null ||
        _month == null ||
        _day == null ||
        _hour == null ||
        _minute == null ||
        _second == null) {
      return null;
    }

    return DateTime(_year!, _month!, _day!, _hour!, _minute!, _second!);
  }

  String? _validateDate(String? text) {
    final dateTime = _tryParseSegments();
    final localizations = MaterialLocalizations.of(context);

    if (dateTime == null) {
      if (_year == null &&
          _month == null &&
          _day == null &&
          _hour == null &&
          _minute == null &&
          _second == null &&
          widget.acceptEmptyDate) {
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
        _controller.value = null;
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
    final labelText = MaterialLocalizations.of(context).dateInputLabel;

    return YaruSegmentedEntry(
      focusNode: widget.focusNode,
      controller: _entryController,
      segments: _segments,
      delimiters: _delimiters,
      validator: _validateDate,
      onChanged: (_) {
        final dateTime = _tryParseSegments();
        _controller.value = dateTime;
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

class YaruDateTimeEntryController extends ValueNotifier<DateTime?> {
  YaruDateTimeEntryController({DateTime? dateTime}) : super(dateTime);

  YaruDateTimeEntryController.now() : super(DateTime.now());

  DateTime? get dateTime => value;
}

extension _StringX on String {
  int? get maybeToInt {
    return int.tryParse(this);
  }

  String get firstCharacter {
    return length > 1 ? substring(0, 1) : this;
  }
}
