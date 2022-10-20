import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import '../constants.dart';

/// A generic wrapper around [PopupMenuButton] that is visually more consistent
/// to buttons and dialogs than [DropdownButton]
class YaruPopupMenuButton<T> extends StatelessWidget {
  const YaruPopupMenuButton({
    super.key,
    required this.initialValue,
    required this.child,
    required this.items,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.position = PopupMenuPosition.under,
  });

  final T initialValue;
  final Widget child;
  final List<PopupMenuItem<T>> items;
  final Function(T)? onSelected;
  final Function()? onCanceled;
  final String? tooltip;
  final PopupMenuPosition position;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium ??
          TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kYaruButtonRadius),
        child: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            padding: EdgeInsets.zero,
            initialValue: initialValue,
            onSelected: onSelected,
            onCanceled: onCanceled,
            tooltip: tooltip,
            itemBuilder: (context) {
              return items;
            },
            child: YaruPopupDecoration(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class YaruPopupDecoration extends StatelessWidget {
  const YaruPopupDecoration({
    super.key,
    required this.child,
    this.childPadding = const EdgeInsets.symmetric(horizontal: 5),
  });

  final Widget child;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kYaruButtonRadius),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: childPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: childPadding,
              child: child,
            ),
            const SizedBox(
              height: 40,
              child: Icon(
                YaruIcons.pan_down,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
