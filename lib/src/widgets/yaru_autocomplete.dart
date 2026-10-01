import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import 'yaru_border_container.dart';

class YaruAutocomplete<T extends Object> extends StatefulWidget {
  const YaruAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsWidth,
    this.optionsMaxHeight = 200.0,
    this.initialValue,
    this.clearedAnnouncement = 'Input cleared',
    this.noOptionsAnnouncement = 'No options found',
    this.optionsCountAnnouncement = _defaultOptionsCountAnnouncement,
    this.announcementTextDirection,
  });

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  ///
  /// If not provided, will build a standard Yaru-style text field by
  /// default.
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T>? onSelected;

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// The width used for the default options list widget.
  ///
  /// The default value is null which means the width will be the same as the
  /// width of the [YaruAutocomplete] widget.
  ///
  /// Note: Passing `double.infinity` makes the options expand to the width of
  /// the screen similarly to the Material design Autocomplete widget.
  final double? optionsWidth;

  /// The maximum height used for the options list widget.
  ///
  /// The default value is 200.
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  /// Announced to screen readers when the input is cleared.
  final String clearedAnnouncement;

  /// Announced to screen readers when no options match the input.
  final String noOptionsAnnouncement;

  /// Builds the message announced to screen readers when options are
  /// available, given the number of options.
  final String Function(int count) optionsCountAnnouncement;

  /// The text direction used for screen reader announcements.
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? announcementTextDirection;

  @override
  State<YaruAutocomplete<T>> createState() => _YaruAutocompleteState<T>();

  static String _defaultOptionsCountAnnouncement(int count) =>
      count == 1 ? '1 option available' : '$count options available';

  static Widget _defaultFieldViewBuilder(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onSubmitted,
  ) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: (value) => onSubmitted(),
    );
  }
}

class _YaruAutocompleteState<T extends Object>
    extends State<YaruAutocomplete<T>> {
  double? _optionsWidth;
  bool _hasNavigated = false;
  Iterable<T> _latestOptions = const [];
  FocusNode? _internalFocusNode;
  FocusOnKeyEventCallback? _originalOnKeyEvent;
  Object? _activeSearchToken;
  TextDirection _announcementTextDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    _updateOptionsWidth();
  }

  @override
  void dispose() {
    _internalFocusNode?.removeListener(_onFocusChanged);
    if (_internalFocusNode != null) {
      _internalFocusNode!.onKeyEvent = _originalOnKeyEvent;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(YaruAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.optionsWidth != oldWidget.optionsWidth) {
      _updateOptionsWidth();
    }
  }

  void _updateOptionsWidth() {
    _optionsWidth = widget.optionsWidth;
    if (_optionsWidth == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final width = (context.findRenderObject() as RenderBox?)?.size.width;
        if (_optionsWidth != width) {
          setState(() => _optionsWidth = width);
        }
      });
    }
  }

  void _onFocusChanged() {
    if (_internalFocusNode?.hasFocus == true) {
      _hasNavigated = false;
    }
  }

  void _announceResultsCount(int count, String text) {
    if (text.isEmpty) {
      SemanticsService.sendAnnouncement(
        View.of(context),
        widget.clearedAnnouncement,
        _announcementTextDirection,
      );
    } else if (count == 0) {
      SemanticsService.sendAnnouncement(
        View.of(context),
        widget.noOptionsAnnouncement,
        _announcementTextDirection,
      );
    } else {
      if (count == 1 && _latestOptions.isNotEmpty) {
        if (widget.displayStringForOption(_latestOptions.first) == text) {
          return;
        }
      }
      SemanticsService.sendAnnouncement(
        View.of(context),
        widget.optionsCountAnnouncement(count),
        _announcementTextDirection,
      );
    }
  }

  FutureOr<Iterable<T>> _wrappedOptionsBuilder(
    TextEditingValue textEditingValue,
  ) {
    _hasNavigated = false;

    final currentToken = Object();
    _activeSearchToken = currentToken;

    final result = widget.optionsBuilder(textEditingValue);
    if (result is Future<Iterable<T>>) {
      return result.then((options) {
        if (mounted && _activeSearchToken == currentToken) {
          _latestOptions = options;
          _announceResultsCount(options.length, textEditingValue.text);
        }
        return options;
      });
    } else {
      _latestOptions = result;
      _announceResultsCount(result.length, textEditingValue.text);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    _announcementTextDirection =
        widget.announcementTextDirection ?? Directionality.of(context);
    return RawAutocomplete<T>(
      displayStringForOption: widget.displayStringForOption,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        if (_internalFocusNode != focusNode) {
          _internalFocusNode?.removeListener(_onFocusChanged);

          if (_internalFocusNode != null) {
            _internalFocusNode!.onKeyEvent = _originalOnKeyEvent;
          }

          _internalFocusNode = focusNode;
          _internalFocusNode?.addListener(_onFocusChanged);

          _originalOnKeyEvent = _internalFocusNode?.onKeyEvent;

          _internalFocusNode?.onKeyEvent = (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if (!_hasNavigated) {
                  _hasNavigated = true;
                  if (_latestOptions.isNotEmpty) {
                    final option = _latestOptions.first;
                    SemanticsService.sendAnnouncement(
                      View.of(context),
                      widget.displayStringForOption(option),
                      _announcementTextDirection,
                    );
                  }
                  return KeyEventResult.handled;
                }
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                _hasNavigated = true;
              }
            }
            return _originalOnKeyEvent?.call(node, event) ??
                KeyEventResult.ignored;
          };
        }

        return widget.fieldViewBuilder(
          context,
          controller,
          focusNode,
          onSubmitted,
        );
      },
      initialValue: widget.initialValue,
      optionsBuilder: _wrappedOptionsBuilder,
      onSelected: (option) {
        widget.onSelected?.call(option);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_internalFocusNode != null && !_internalFocusNode!.hasFocus) {
            _internalFocusNode!.requestFocus();
          }
        });
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _YaruAutocompleteOptions<T>(
          displayStringForOption: widget.displayStringForOption,
          onSelected: onSelected,
          options: options,
          optionsWidth: _optionsWidth,
          maxOptionsHeight: widget.optionsMaxHeight,
          announcementTextDirection: _announcementTextDirection,
        );
      },
    );
  }
}

class _YaruAutocompleteOptions<T extends Object> extends StatefulWidget {
  const _YaruAutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.optionsWidth,
    required this.maxOptionsHeight,
    required this.announcementTextDirection,
  });

  final AutocompleteOptionToString<T> displayStringForOption;
  final AutocompleteOnSelected<T> onSelected;
  final Iterable<T> options;
  final double? optionsWidth;
  final double maxOptionsHeight;
  final TextDirection announcementTextDirection;

  @override
  State<_YaruAutocompleteOptions<T>> createState() =>
      _YaruAutocompleteOptionsState<T>();
}

class _YaruAutocompleteOptionsState<T extends Object>
    extends State<_YaruAutocompleteOptions<T>> {
  int _lastAnnouncedIndex = 0;

  @override
  void didUpdateWidget(covariant _YaruAutocompleteOptions<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _lastAnnouncedIndex = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final highlighted = AutocompleteHighlightedOption.of(context);

    if (highlighted != _lastAnnouncedIndex) {
      _lastAnnouncedIndex = highlighted;

      if (highlighted >= 0 && highlighted < widget.options.length) {
        final option = widget.options.elementAt(highlighted);
        SemanticsService.sendAnnouncement(
          View.of(context),
          widget.displayStringForOption(option),
          widget.announcementTextDirection,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: ExcludeFocus(
        child: YaruBorderContainer(
          width: widget.optionsWidth,
          clipBehavior: Clip.antiAlias,
          color: theme.menuTheme.style?.backgroundColor?.resolve({}),
          constraints: BoxConstraints(maxHeight: widget.maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              return Builder(
                builder: (context) {
                  final highlighted = AutocompleteHighlightedOption.of(context);
                  if (index == highlighted) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        Scrollable.ensureVisible(context, alignment: 0.5);
                      }
                    });
                  }
                  final option = widget.options.elementAt(index);

                  return MenuItemButton(
                    requestFocusOnHover: false,
                    onPressed: () => widget.onSelected(option),
                    style: MenuItemButton.styleFrom(
                      backgroundColor: index == highlighted
                          ? Theme.of(context).focusColor
                          : null,
                    ),
                    child: Text(widget.displayStringForOption(option)),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
