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
    this.focusNode,
    this.initialDate,
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
  });

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// If provided, it will be used as the default value of the field.
  final DateTime? initialDate;

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
  late final YaruSegmentedEntryController _controller;

  late final YaruEntrySegment _daySegment;
  late final YaruEntrySegment _monthSegment;
  late final YaruEntrySegment _yearSegment;
  late final YaruEntrySegment _hourSegment;
  late final YaruEntrySegment _minuteSegment;

  final _segments = <YaruEntrySegment>[];

  final _previousSegmentsValue = <YaruEntrySegment, int?>{};

  int? get _year => _yearSegment.value.maybeToInt;
  int? get _month => _monthSegment.value.maybeToInt;
  int? get _day => _daySegment.value.maybeToInt;
  int? get _hour => _hourSegment.value.maybeToInt;
  int? get _minute => _minuteSegment.value.maybeToInt;

  @override
  void initState() {
    super.initState();

    _daySegment = YaruEntrySegment.fixed(
      intialInput: widget.initialDate?.day.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('d'),
    );
    _daySegment.addListener(_dateTimeSegmentListener(_daySegment, 3, 31));

    _monthSegment = YaruEntrySegment.fixed(
      intialInput: widget.initialDate?.month.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('m'),
    );
    _monthSegment.addListener(_dateTimeSegmentListener(_monthSegment, 1, 12));

    _yearSegment = YaruEntrySegment(
      intialInput: widget.initialDate?.year.toString(),
      minLength: widget.firstDate.year.toString().length,
      maxLength: widget.lastDate.year.toString().length,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('y'),
    );

    _hourSegment = YaruEntrySegment.fixed(
      intialInput: widget.initialDate?.hour.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('h'),
    );
    _hourSegment.addListener(_dateTimeSegmentListener(_hourSegment, 2, 23));

    _minuteSegment = YaruEntrySegment.fixed(
      intialInput: widget.initialDate?.minute.toString(),
      length: 2,
      isNumeric: true,
      inputFormatter: _dateTimeSegmentFormatter('m'),
    );
    _minuteSegment.addListener(_dateTimeSegmentListener(_minuteSegment, 5, 59));

    _segments.addAll([
      _yearSegment,
      _monthSegment,
      _daySegment,
      _hourSegment,
      _minuteSegment,
    ]);

    for (final segment in _segments) {
      _previousSegmentsValue.addAll({segment: segment.value.maybeToInt});
    }

    _controller = YaruSegmentedEntryController(
      length: _segments.length,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSegmentsOrder();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _daySegment.dispose();
    _monthSegment.dispose();
    _yearSegment.dispose();
    _hourSegment.dispose();
    _minuteSegment.dispose();

    super.dispose();
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
            _controller.maybeSelectNextSegment();
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

  void _updateSegmentsOrder() {
    setState(() {
      _segments.clear();

      const year = 2001;
      const month = 12;
      const day = 31;

      final localizations = MaterialLocalizations.of(context);
      final dateSeparator = localizations.dateSeparator;
      final formattedDateTime =
          localizations.formatCompactDate(DateTime(year, month, day));
      final dateParts = formattedDateTime.split(dateSeparator);

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
      ]);
    });
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
        _minute == null) {
      return null;
    }

    return DateTime(_year!, _month!, _day!, _hour!, _minute!);
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
        for (final segment in _segments) {
          segment.input = null;
        }
        _controller.selectFirstSegment();
      },
      icon: const Icon(YaruIcons.edit_clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final dateSeparator = localizations.dateSeparator;
    final labelText = localizations.dateInputLabel;

    final delimiters = [dateSeparator, dateSeparator, ' ', ':'];

    return YaruSegmentedEntry(
      focusNode: widget.focusNode,
      controller: _controller,
      segments: _segments,
      delimiters: delimiters,
      validator: _validateDate,
      onChanged: (_) => widget.onChanged?.call(_tryParseSegments()),
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

extension _StringX on String {
  int? get maybeToInt {
    return int.tryParse(this);
  }
}
