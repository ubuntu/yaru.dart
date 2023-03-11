import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'yaru_border_container.dart';

class YaruAutocomplete<T extends Object> extends StatelessWidget {
  const YaruAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsWidth,
    this.optionsMaxHeight = 200.0,
    this.initialValue,
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
  /// The default value is null.
  final double? optionsWidth;

  /// The maximum height used for the options list widget.
  ///
  /// The default value is 200.
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      optionsViewBuilder: (context, onSelected, options) {
        return _YaruAutocompleteOptions<T>(
          displayStringForOption: displayStringForOption,
          onSelected: onSelected,
          options: options,
          optionsWidth: optionsWidth,
          maxOptionsHeight: optionsMaxHeight,
        );
      },
    );
  }

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

class _YaruAutocompleteOptions<T extends Object> extends StatelessWidget {
  const _YaruAutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.optionsWidth,
    required this.maxOptionsHeight,
  });

  final AutocompleteOptionToString<T> displayStringForOption;
  final AutocompleteOnSelected<T> onSelected;
  final Iterable<T> options;
  final double? optionsWidth;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topLeft,
      child: YaruBorderContainer(
        width: optionsWidth,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.brightness == Brightness.dark
            ? colorScheme.surfaceVariant
            : colorScheme.surface,
        constraints: BoxConstraints(maxHeight: maxOptionsHeight),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return Builder(
              builder: (context) {
                final highlighted = AutocompleteHighlightedOption.of(context);
                if (index == highlighted) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Scrollable.ensureVisible(context, alignment: 0.5);
                  });
                }
                final option = options.elementAt(index);
                return MenuItemButton(
                  requestFocusOnHover: false,
                  onPressed: () => onSelected(option),
                  style: MenuItemButton.styleFrom(
                    backgroundColor: index == highlighted
                        ? Theme.of(context).focusColor
                        : null,
                  ),
                  child: Text(displayStringForOption(option)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
