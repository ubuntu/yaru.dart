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
    required this.itemBuilder,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.position = PopupMenuPosition.under,
    this.childPadding = const EdgeInsets.symmetric(horizontal: 5),
  });

  final T initialValue;
  final Widget child;
  final Function(T)? onSelected;
  final Function()? onCanceled;
  final String? tooltip;
  final PopupMenuPosition position;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kYaruButtonRadius),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton(
          padding: EdgeInsets.zero,
          initialValue: initialValue,
          onSelected: onSelected,
          onCanceled: onCanceled,
          tooltip: tooltip,
          itemBuilder: itemBuilder,
          child: _YaruPopupDecoration(
            child: child,
            childPadding: childPadding,
          ),
        ),
      ),
    );
  }
}

class _YaruPopupDecoration extends StatelessWidget {
  const _YaruPopupDecoration({
    // ignore: unused_element
    super.key,
    required this.child,
    required this.childPadding,
  });

  final Widget child;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
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
      ),
    );
  }
}
