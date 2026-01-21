import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/widgets.dart';

typedef DateTimeCallback = void Function(DateTime datetime);

const int _maxMonthRowCount = 6;

class YaruMonthGrid extends StatelessWidget {
  const YaruMonthGrid({
    super.key,
    required this.displayedMonth,
    required this.dayItemBuilder,
    this.dayHeaderBuilder,
  });

  final DateTime displayedMonth;

  final Widget Function(DateTime day) dayItemBuilder;

  final Widget Function(int index)? dayHeaderBuilder;

  List<Widget> _buildHeaderItems(MaterialLocalizations localizations) {
    if (dayHeaderBuilder == null) {
      return [];
    }

    final items = <Widget>[];
    for (
      var i = localizations.firstDayOfWeekIndex;
      items.length < DateTime.daysPerWeek;
      i = (i + 1) % DateTime.daysPerWeek
    ) {
      items.add(ExcludeSemantics(child: dayHeaderBuilder!.call(i)));
    }
    return items;
  }

  List<Widget> _buildDayItems(MaterialLocalizations localizations) {
    final items = <Widget>[];

    final year = displayedMonth.year;
    final month = displayedMonth.month;

    final dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    final daysInGrid = DateTime.daysPerWeek * _maxMonthRowCount - dayOffset;

    var day = -dayOffset;
    while (day < daysInGrid) {
      day++;
      final dayToBuild = DateTime(year, month, day);
      items.add(dayItemBuilder(dayToBuild));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final items = <Widget>[];
    items.addAll(_buildHeaderItems(localizations));
    items.addAll(_buildDayItems(localizations));

    return GridView.custom(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: dayHeaderBuilder != null
          ? const _YaruMonthGridDelegate(headerRow: true)
          : const _YaruMonthGridDelegate(headerRow: false),
      childrenDelegate: SliverChildListDelegate(
        items,
        addRepaintBoundaries: false,
      ),
    );
  }
}

class _YaruMonthGridDelegate extends SliverGridDelegate {
  const _YaruMonthGridDelegate({required this.headerRow});

  final bool headerRow;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek;
    final tileWidth = constraints.crossAxisExtent / columnCount;
    final maxMonthRowCount = _maxMonthRowCount + (headerRow ? 1 : 0);
    final tileHeight = (constraints.viewportMainAxisExtent / maxMonthRowCount)
        .truncate()
        .toDouble();

    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YaruMonthGridDelegate oldDelegate) => false;
}

class YaruDayPicker extends StatefulWidget {
  const YaruDayPicker({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDaySelected,
  });

  final DateTime? initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTimeCallback? onDaySelected;

  @override
  State<YaruDayPicker> createState() => _YaruDayPickerState();
}

class _YaruDayPickerState extends State<YaruDayPicker> {
  late DateTime displayedMonth;
  late DateTime? selectedDay;

  bool yearSelectionMode = false;

  @override
  void initState() {
    final now = DateTime.now();
    var initial = widget.initialDate ?? now;

    if (initial.isBefore(widget.firstDate)) {
      initial = widget.firstDate;
    } else if (initial.isAfter(widget.lastDate)) {
      initial = widget.lastDate;
    }

    displayedMonth = initial;
    selectedDay = initial;

    super.initState();
  }

  Widget _buildTopbar() {
    return Row(
      children: [
        if (!yearSelectionMode)
          YaruIconButton(
            tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
            onPressed: () => setState(() {
              displayedMonth = DateUtils.addMonthsToMonthDate(
                displayedMonth,
                -1,
              );
            }),
            icon: const Icon(YaruIcons.pan_start),
          ),
        Expanded(
          child: Center(
            child: OutlinedButton(
              onPressed: () => setState(() {
                yearSelectionMode = !yearSelectionMode;
              }),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat.yMMM().format(displayedMonth)),
                  const SizedBox(width: 5),
                  yearSelectionMode
                      ? const Icon(YaruIcons.pan_up)
                      : const Icon(YaruIcons.pan_down),
                ],
              ),
            ),
          ),
        ),
        if (!yearSelectionMode)
          YaruIconButton(
            tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
            onPressed: () => setState(() {
              displayedMonth = DateUtils.addMonthsToMonthDate(
                displayedMonth,
                1,
              );
            }),
            icon: const Icon(YaruIcons.pan_end),
          ),
      ],
    );
  }

  Widget _buildMonthYearSelection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _YaruMonthPicker(
            initialMonth: displayedMonth,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onMonthSelected: (month) => setState(() {
              displayedMonth = displayedMonth.copyWith(month: month.month);
            }),
          ),
        ),
        Expanded(
          child: _YaruYearPicker(
            initialYear: displayedMonth,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onYearSelected: (year) => setState(() {
              displayedMonth = displayedMonth.copyWith(year: year.year);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelection() {
    return YaruMonthGrid(
      displayedMonth: displayedMonth,
      dayItemBuilder: (day) {
        final now = DateTime.now();
        final selected = DateUtils.isSameDay(day, selectedDay);
        final currentMonth = DateUtils.isSameMonth(day, displayedMonth);
        final today = day.day == now.day && currentMonth;

        return _YaruDayButton(
          day: day,
          today: today,
          selected: selected,
          currentMonth: currentMonth,
          onTap: () => setState(() {
            selectedDay = day;
            if (!DateUtils.isSameMonth(day, displayedMonth)) {
              displayedMonth = day;
            }
            widget.onDaySelected?.call(day);
          }),
        );
      },
      dayHeaderBuilder: (i) => _YaruDayHeader(index: i),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopbar(),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: yearSelectionMode
                ? _buildMonthYearSelection()
                : _buildDaySelection(),
          ),
        ],
      ),
    );
  }
}

class _YaruDayHeader extends StatelessWidget {
  const _YaruDayHeader({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(child: Text(localizations.narrowWeekdays[index])),
      ),
    );
  }
}

class _YaruDayButton extends StatelessWidget {
  const _YaruDayButton({
    required this.day,
    required this.today,
    required this.selected,
    required this.currentMonth,
    this.onTap,
  });

  final DateTime day;

  final bool today;
  final bool selected;
  final bool currentMonth;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    late final Color? color;
    if (selected) {
      color = colorScheme.onPrimary.withValues(alpha: currentMonth ? 1 : .5);
    } else {
      color = colorScheme.onSurface.withValues(alpha: currentMonth ? 1 : .5);
    }

    late final Color? background;
    if (selected) {
      background = colorScheme.primary.withValues(
        alpha: currentMonth ? 1 : .25,
      );
    } else if (today) {
      background = colorScheme.onSurface.withValues(alpha: 0.1);
    } else {
      background = colorScheme.surface.withValues(alpha: 0);
    }

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: YaruFocusBorder(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          shape: const CircleBorder(),
          color: background,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: Text(day.day.toString(), style: TextStyle(color: color)),
            ),
          ),
        ),
      ),
    );
  }
}

class _YaruMonthPicker extends StatefulWidget {
  const _YaruMonthPicker({
    required this.initialMonth,
    required this.firstDate,
    required this.lastDate,
    required this.onMonthSelected,
  });

  final DateTime initialMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeCallback onMonthSelected;

  @override
  State<_YaruMonthPicker> createState() => _YaruMonthPickerState();
}

class _YaruMonthPickerState extends State<_YaruMonthPicker> {
  late DateTime selectedMonth;
  late final PageController controller;

  @override
  void initState() {
    selectedMonth = widget.initialMonth;

    final validMonth = selectedMonth.month.clamp(1, DateTime.monthsPerYear);
    selectedMonth = selectedMonth.copyWith(month: validMonth);

    controller = PageController(
      viewportFraction: .2,
      initialPage: validMonth - 1,
      keepPage: false,
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return _YaruMonthYearPicker(
      controller: controller,
      itemCount: DateTime.monthsPerYear,
      itemBuilder: (context, index) {
        return _YaruMonthYearPickerItem(
          today: now.month - 1 == index,
          selected: selectedMonth.month - 1 == index,
          onTap: () => setState(() {
            selectedMonth = selectedMonth.copyWith(month: index + 1);
            widget.onMonthSelected(selectedMonth);
            controller.jumpToPage(selectedMonth.month - 1);
          }),
          child: Text(
            DateFormat.MMMM().format(selectedMonth.copyWith(month: index + 1)),
          ),
        );
      },
    );
  }
}

class _YaruYearPicker extends StatefulWidget {
  const _YaruYearPicker({
    required this.initialYear,
    required this.firstDate,
    required this.lastDate,
    required this.onYearSelected,
  });

  final DateTime initialYear;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeCallback onYearSelected;

  @override
  State<_YaruYearPicker> createState() => _YaruYearPickerState();
}

class _YaruYearPickerState extends State<_YaruYearPicker> {
  late DateTime selectedYear;
  late final PageController controller;

  @override
  void initState() {
    selectedYear = widget.initialYear;

    if (selectedYear.isBefore(widget.firstDate)) {
      selectedYear = widget.firstDate;
    } else if (selectedYear.isAfter(widget.lastDate)) {
      selectedYear = widget.lastDate;
    }

    final initialPage = (selectedYear.year - widget.firstDate.year).clamp(
      0,
      widget.lastDate.year - widget.firstDate.year,
    );
    controller = PageController(
      viewportFraction: .2,
      initialPage: initialPage,
      keepPage: false,
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return _YaruMonthYearPicker(
      controller: controller,
      itemCount: widget.lastDate.year - widget.firstDate.year + 1,
      itemBuilder: (context, index) {
        return _YaruMonthYearPickerItem(
          today: now.year - widget.firstDate.year == index,
          selected: selectedYear.year - widget.firstDate.year == index,
          onTap: () {
            selectedYear = selectedYear.copyWith(
              year: widget.firstDate.year + index,
            );
            widget.onYearSelected(selectedYear);
            controller.jumpToPage(selectedYear.year - widget.firstDate.year);
          },
          child: Text((widget.firstDate.year + index).toString()),
        );
      },
    );
  }
}

class _YaruMonthYearPicker extends StatelessWidget {
  const _YaruMonthYearPicker({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
  });

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  void _jumpToPreviousPage() {
    final previousPage = (controller.page?.toInt() ?? 0) - 1;
    if (previousPage >= 0) {
      controller.jumpToPage(previousPage);
    }
  }

  void _jumpToNextPage() {
    final nextPage = (controller.page?.toInt() ?? 0) + 1;
    if (nextPage < itemCount) {
      controller.jumpToPage(nextPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        children: [
          _YaruMonthYearPickerItem(
            onTap: _jumpToPreviousPage,
            child: const Icon(YaruIcons.pan_up),
          ),
          Expanded(
            child: PageView.builder(
              pageSnapping: false,
              controller: controller,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(), // Add this
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
          ),
          _YaruMonthYearPickerItem(
            onTap: _jumpToNextPage,
            child: const Icon(YaruIcons.pan_down),
          ),
        ],
      ),
    );
  }
}

class _YaruMonthYearPickerItem extends StatelessWidget {
  const _YaruMonthYearPickerItem({
    required this.child,
    this.today = false,
    this.selected = false,
    required this.onTap,
  });

  final Widget child;

  final bool today;
  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    late Color? color;
    if (selected) {
      color = colorScheme.onPrimary;
    } else {
      color = colorScheme.onSurface;
    }

    late Color? background;
    if (selected) {
      background = colorScheme.primary;
    } else if (today) {
      background = colorScheme.onSurface.withValues(alpha: 0.1);
    } else {
      background = null;
    }

    return Material(
      color: background,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(color: color),
            child: child,
          ),
        ),
      ),
    );
  }
}
